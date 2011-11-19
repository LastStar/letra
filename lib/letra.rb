require 'tmpdir'
require 'fileutils'

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
    FileUtils.rm "#{destination}/#{font_name}.ttf"
    FileUtils.rm "#{destination}/#{font_name}.afm" if File.exists?("#{destination}/#{font_name}.afm")
  end
  
  def copy_to_destination
    FileUtils.cp_r @tmp_dir + '/.', destination
    File.rename(destination + '/' + File.basename(source_file), destination + '/' + font_name + '.otf')
  end
  
  def fontforge!
    `fontforge -lang=ff -c 'Open($1);Generate("#{@tmp_dir}/#{font_name}.ttf");Generate("#{@tmp_dir}/#{font_name}.woff");Generate("#{@tmp_dir}/#{font_name}" + ".svg");' #{@tmp_dir}/#{File.basename source_file} 2>/dev/null`    
  end
  
  def make_eot_from_ttf
    `ttf2eot #{destination}/#{font_name}.ttf > #{destination}/#{font_name}.eot`
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