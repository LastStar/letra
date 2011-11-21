$: << File.expand_path(File.dirname(__FILE__))
require 'tmpdir'
require 'tempfile'
require 'fileutils'
require 'letra/enc_parser'
require 'erb'

class Letra
  attr_accessor :source_file, :tmp_dir, :destination, :file_name,
                :font_name, :selected_glyph_ids, :script_file
  
  def self.load(options)
    letra = Letra.new
    letra.source_file = options[:source_file]
    letra.destination = options[:destination]
    letra.font_name   = options[:font_name]
    letra.selected_glyph_ids = EncParser.parse(IO.read(options[:glyph_indices])) if options[:glyph_indices]
    return letra
  end
  
  def initialize
    raise "Fontforge is not in PATH" unless fontforge_installed?
    raise "TTF2EOT is not in PATH"   unless ttf2eot_installed?
  end
  
  def convert!
    begin
      create_tmp_dir
      copy_original_to_tmp_dir
      select_glyphs if selected_glyph_ids
      convert_to_ttf_woff_and_svg
      copy_to_destination
      make_eot_from_ttf
      true
    rescue
      false
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
    FileUtils.rm font_file_path('ttf')
    FileUtils.rm font_file_path('afm') if File.exists?(font_file_path('afm'))
    # FileUtils.rm '/tmp/reduce.pe' rescue nil
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
end