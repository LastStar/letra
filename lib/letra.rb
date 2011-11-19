require 'tmpdir'
require 'fileutils'

class Letra
  attr_accessor :source_file, :tmp_dir, :destination, :file_name
  
  def self.load(options)
    raise "Source file does not exists " unless File.exists?(options[:source_file])
    letra = Letra.new
    letra.source_file = options[:source_file]
    letra.destination = options[:destination]
    return letra
  end
  
  def initialize
    raise "Fontforge is not in PATH" unless fontforge_installed?
    raise "TTF2EOT is not in PATH"   unless ttf2eot_installed?
  end
  
  def convert!
    create_tmp_dir
    copy_original_to_tmp_dir
    fontforge!
    copy_to_destination
    make_eot_from_ttf
    clean
  end
  
  def destination
    @destination ||= File.dirname source_file
  end

  private
  
  def create_tmp_dir
    @tmp_dir ||= Dir.mktmpdir
  end
  
  def copy_original_to_tmp_dir
    FileUtils.cp source_file, @tmp_dir
  end
  
  def clean
    FileUtils.rm_rf @tmp_dir
    FileUtils.rm "#{destination}/#{file_name}.ttf"
  end
  
  def copy_to_destination
    FileUtils.cp_r @tmp_dir + '/.', destination
  end
  
  def file_name
    @file_name ||= File.basename(source_file, ".otf")
  end
  
  def fontforge!
    `fontforge -lang=ff -c 'Open($1);Generate($1:r + ".ttf");Generate($1:r + ".woff");Generate($1:r + ".svg");' #{@tmp_dir}/#{file_name}.otf 2>/dev/null`    
  end
  
  def make_eot_from_ttf
    `ttf2eot #{destination}/#{file_name}.ttf > #{destination}/#{file_name}.eot`
  end
  
  def fontforge_installed?
    is_in_path?('fontforge')
  end
  
  def ttf2eot_installed?
    is_in_path?('ttf2eot')
  end
  
  def is_in_path?(file)
    ENV["PATH"].split(':').any? {|dir| File.exist? dir + "/#{file}"}
  end
end