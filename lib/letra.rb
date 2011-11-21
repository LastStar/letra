require 'tmpdir'
require 'fileutils'
require './lib/letra/enc_parser'

class Letra
  attr_accessor :source_file, :tmp_dir, :destination, :file_name, :font_name
  
  def self.load(options)
    letra = Letra.new
    letra.source_file = options[:source_file]
    letra.destination = options[:destination]
    letra.font_name   = options[:font_name]
    return letra
  end
  
  def initialize
    raise "Fontforge is not in PATH" unless fontforge_installed?
    raise "TTF2EOT is not in PATH"   unless ttf2eot_installed?
  end
  
  def convert!
    create_tmp_dir
    copy_original_to_tmp_dir
    convert_to_ttf_woff_and_svg
    copy_to_destination
    make_eot_from_ttf
    clean
  end
  
  private
  
  def create_tmp_dir
    @tmp_dir ||= Dir.mktmpdir
  end
  
  def copy_original_to_tmp_dir
    FileUtils.cp source_file, @tmp_dir
  end
  
  def convert_to_ttf_woff_and_svg
    `fontforge -lang=ff -c \
     'Open($1); \
     Generate("#{tmp_file_path('ttf')}"); \
     Generate("#{tmp_file_path('woff')}"); \
     Generate("#{tmp_file_path('svg')}");' \
     #{File.join(@tmp_dir, File.basename(source_file))} 2>/dev/null`    
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
end