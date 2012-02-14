$: << File.expand_path(File.dirname(__FILE__))
require 'tmpdir'
require 'tempfile'
require 'fileutils'
require 'letra/enc_parser'
require 'letra/enc_builder'
require 'erb'

class Letra
  attr_accessor :source_file, :tmp_dir, :destination, :file_name,
                :font_name, :selected_glyphs, :script_file,
                :export_to, :without, :suffix_for_numbers

  def self.load(options)
    letra = Letra.new
    letra.source_file = options[:source_file]
    letra.destination = options[:destination]
    letra.font_name   = options[:font_name]
    letra.export_to   = options[:export_to]
    letra.selected_glyphs = options[:glyph_indices] if options[:glyph_indices]
    letra.without     = options[:without]
    letra.suffix_for_numbers = options[:suffix_for_numbers]
    return letra
  end

  def initialize
    raise "Fontforge is not in PATH" unless fontforge_installed?
    raise "TTF2EOT is not in PATH"   unless ttf2eot_installed?
    @features = {:kerning => "'kern' Horizontal Kerning in Latin lookup 0",
                 :small_caps => "'smcp' Lowercase to Small Capitals lookup 9",
                 :all_small_caps => "'c2sc' Capitals to Small Capitals lookup 6",
                 :ligatures => "'liga' Standard Ligatures lookup 34",
                 :slashed_zero => "'zero' Slashed Zero lookup 38"}
  end

  def convert!
    begin
      create_tmp_dir
      copy_original_to_tmp_dir
      select_glyphs if selected_glyphs
      convert_to_ttf_woff_and_svg
      copy_to_destination
      make_eot_from_ttf
      true
    rescue Exception => e
      false
      p e.backtrace
    ensure
      clean
    end
  end

  private

  def create_tmp_dir
    @tmp_dir ||= Dir.mktmpdir("letra-")
  end

  def copy_original_to_tmp_dir
    FileUtils.cp source_file, @tmp_dir
  end

  def select_glyphs
    selected_glyphs = load_selected_glyph_ids()
    removed_features = load_removed_features()
    template = ERB.new(IO.read(File.expand_path('letra/views/reduce.pe.erb', File.dirname(__FILE__))))
    File.open('/tmp/reduce.pe',  'wb') {|f| f.write(template.result(binding)) }
    `fontforge -lang=ff -script /tmp/reduce.pe #{tmp_original_file_path} 2>/dev/null`
  end

  def convert_to_ttf_woff_and_svg
    `fontforge -lang=ff -c \
     'Open($1); \
     Generate("#{tmp_file_path('ttf')}"); \
     Generate("#{tmp_file_path('woff')}"); \
     Generate("#{tmp_file_path('svg')}");' \
     #{tmp_original_file_path} 2>/dev/null`
  end

  def copy_to_destination
    FileUtils.cp_r @tmp_dir + '/.', destination
    File.rename(File.join(destination, File.basename(source_file)), font_file_path('otf'))
  end

  def make_eot_from_ttf
    `ttf2eot #{font_file_path('ttf')}> #{font_file_path('eot')}`
  end

  def clean
    FileUtils.rm_rf @tmp_dir
    FileUtils.rm font_file_path('ttf') unless  export_to.include?(:ttf)
    FileUtils.rm font_file_path('eot') unless  export_to.include?(:eot)
    FileUtils.rm font_file_path('woff') unless export_to.include?(:woff)
    FileUtils.rm font_file_path('svg') unless  export_to.include?(:svg)
    FileUtils.rm font_file_path('otf') unless  export_to.include?(:otf)
    FileUtils.rm font_file_path('afm') if File.exists?(font_file_path('afm'))
    #FileUtils.rm '/tmp/reduce.pe' rescue nil
    File.delete(File.join(destination, File.basename(source_file, File.extname(source_file)) + '.afm')) rescue nil
  end

  def fontforge_installed?
    is_in_path?('fontforge')
  end

  def ttf2eot_installed?
    is_in_path?('ttf2eot')
  end

  def is_in_path?(file)
    ENV["PATH"].split(':').any? {|dir| File.exist? File.join(dir, file)}
  end

  def tmp_file_path(extension = nil)
    File.join(@tmp_dir, font_file_name(extension))
  end

  def font_file_path(extension = nil)
    File.join(destination, font_file_name(extension))
  end

  def font_file_name(extension = nil)
    [font_name, extension].compact.join('.')
  end

  def tmp_original_file_path
    File.join(@tmp_dir, File.basename(source_file))
  end

  def load_selected_glyph_ids
    if self.selected_glyphs.is_a?(String)
      return EncParser.parse(IO.read(self.selected_glyphs))
    elsif self.selected_glyphs.is_a?(Hash)
      return EncBuilder.build_enc(self.selected_glyphs)
    end
  end

  def load_removed_features
    if self.without
      @features.select{|k,v| self.without.include?(k)}.values
    else
      []
    end
  end
end
