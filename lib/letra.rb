require 'rubypython'
require 'reot'

class Letra
  attr_reader :font, :fontforge, :fontfile
  attr_accessor :destination, :name

  def self.open(fontfile, &block)
    letra = Letra.new(fontfile)
    yield(letra)
    letra.close
  end

  def initialize(fontfile)
    RubyPython.start
    RubyPython.import('sys').path.append(File.dirname(__FILE__))
    @fontforge = RubyPython.import('fontforge')
    @pytra = RubyPython.import('pytra')
    @fontfile = fontfile
    @font = fontforge.open(RubyPython::Conversion.rtopString(fontfile))
    @name = File.basename(fontfile, File.extname(fontfile))
  end

  def close
    @font.close
    @fontforge = nil
    @font = nil
    @name = nil
  end

  def lookups
    lookups_hash ||= load_lookups
  end

  def kerning?
    @kerning ||= @font.gpos_lookups.rubify.to_s.include?('kern')
  end

  def remove_kerning!
    kerning_tables = @font.gpos_lookups.rubify.select{|table| table.include?('kern')}
    kerning_tables.each{|table| @font.removeLookup(table)}
  end

  def generate!(formats)
    formats = Array(formats).collect(&:to_s).sort.reverse
    raise "Invalid output format" if invalid_formats?(formats)
    formats.select {|f| f != 'eot'}.each do |format|
      @font.generate(generated_font_file(format))
    end
    if formats.include?('eot')
      ttf = formats.include?('ttf')
      @font.generate(generated_font_file('ttf')) unless ttf
      Reot.convert!(generated_font_file('ttf'), generated_font_file('eot'))
      File.delete(generated_font_file('ttf')) unless ttf
    end
  end

  def glyphs_count
    RubyPython::Conversion.ptorInt(@pytra.glyphs_count(@font).pObject.pointer)
  end

  def reduce!(characters)
    font.selection.none()
    characters.each_char do |character|
      font.selection.select(["more", nil], character.ord)
    end
    font.selection.invert()
    font.clear()
    # font.encoding = "compacted"
  end

  def apply_substitution(lookup)
    @pytra.apply_substitution(@font, lookup).rubify
    true
  end

  private
  def load_lookups
    @lookups_hash = {}
    lookups = RubyPython::Conversion.ptorTuple(@pytra.gsub_lookups(@font).pObject.pointer)
    lookups.collect do |lookup|
       lookup = lookup.scan(/'(?<tag>....)' (?<name>.*) lookup /).flatten
       @lookups_hash[lookup[0]] = lookup[1] if lookup[0]
     end
    @lookups_hash
  end

  def invalid_formats?(formats)
    formats.select{|f| f.to_s.scan(/otf|ttf|woff|eot|svg/).any?}.count != formats.count
  end

  def generated_font_file(extension)
    File.join(self.destination, "#{name}.#{extension}")
  end
end
