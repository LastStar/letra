require 'rubypython'
require 'reot'

class Letra
  attr_reader :font, :fontforge, :fontfile
  attr_accessor :destination, :name

  def initialize(fontfile)
    RubyPython.start
    @fontforge = RubyPython.import('fontforge')
    @fontfile = fontfile
    @font = fontforge.open(fontfile)
    @name = File.basename(fontfile, File.extname(fontfile))
  end

  def lookups
    lookups_hash ||= load_lookups
  end

  def kerning?
    @kerning ||= @font.gpos_lookups.rubify.to_s.include?('kern')
  end

  def generate!(formats)
    formats = Array(formats)
    raise "Invalid output format" if invalid_formats?(formats)
    formats.each do |format|
      @font.generate(generated_font_file(format)) if format.to_s != 'eot'
      Reot.convert!(fontfile, generated_font_file('eot')) if format.to_s == 'eot'
    end
  end

  private
  def load_lookups
    @lookups_hash = {}
    @font.gsub_lookups.rubify.collect do |lookup|
      lookup = lookup.scan(/'(?<tag>....)' (?<name>.*) lookup /).flatten
      @lookups_hash[lookup[0]] = lookup[1]
    end
    @lookups_hash
  end

  def invalid_formats?(formats)
    formats.select{|f| f.to_s.scan(/otf|ttf|eot|svg/).any?}.count != formats.count
  end

  def generated_font_file(extension)
    File.join(self.destination, "#{name}.#{extension}")
  end
end
