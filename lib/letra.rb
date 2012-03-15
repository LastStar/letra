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
    @fontforge = RubyPython.import('fontforge')
    @fontfile = fontfile
    @font = fontforge.open(fontfile)
    @name = File.basename(fontfile, File.extname(fontfile))
  end

  def close
    @font.close
  end

  def lookups
    lookups_hash ||= load_lookups
  end

  def kerning?
    @kerning ||= @font.gpos_lookups.rubify.to_s.include?('kern')
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
    @font.glyphs().to_enum.count
  end

  def reduce!(characters)
    font.selection.none()
    characters.each_char do |character|
      font.selection.select(["more", nil], character)
    end
    font.selection.invert()
    font.clear()
    font.encoding = "compacted"
  end

  def apply_substitution(lookup)
    @font.glyphs().to_enum.each do |glyph|
      substitutions = glyph.getPosSub("*").rubify
      sub = substitutions.select {|s| s[0].include?(lookup) and s[1].include?("Substitution")}.flatten
      if sub.any?
        target = sub.flatten.last
        @font.selection.select(target)
        @font.copy()
        @font.selection.select(glyph.glyphname)
        @font.paste()
      end
    end
  end

  private
  def load_lookups
    @lookups_hash = {}
    @font.gsub_lookups.rubify.collect do |lookup|
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
