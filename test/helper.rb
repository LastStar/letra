require 'bundler'
require 'minitest/autorun'
require 'fileutils'
require 'tmpdir'

Bundler.setup
require 'letra'
require 'glyphr'

class Letra::TestCase < MiniTest::Unit::TestCase
  attr_accessor :font, :letra, :dir
  def setup
    self.dir   = Dir.mktmpdir('letra')
    self.letra = Letra.new('test/fonts/font.otf')
    self.letra.destination = dir
  end

  def teardown
    self.letra.close
    FileUtils.remove_entry_secure self.dir
  end

  private

  def generated_font_path(extension)
    filepath = File.join(dir, "#{letra.name}.#{extension}")
  end

  def assert_generated_file_format(extension, test_with_fontforge = true)
    filepath = generated_font_path(extension)
    assert File.exists?(filepath), "#{filepath} doesn't exists"
    assert File.size(filepath) > 0, "#{filepath} is empty"
    assert_file_is_valid_font(filepath) if test_with_fontforge
  end

  def assert_not_generated_file_format(extension)
    filepath = generated_font_path(extension)
    assert !File.exists?(filepath), "#{filepath} exists, but should not!"
  end

  def assert_file_is_valid_font(filepath)
    fontforge = RubyPython.import('fontforge')
    value = fontforge.open(filepath) rescue false
    assert value, "#{filepath} is not valid font"
  end

  def assert_rendered_text(text, image)
    letra.generate!(:otf)
    renderer = Glyphr::Renderer.new(generated_font_path('otf'), 72)
    renderer.image_width = 150
    renderer.render(text)
    generated_image = File.join(self.dir, 'output.png')
    renderer.image.save(generated_image)
    assert_files(generated_image, image)
  end

  def assert_files(file1, file2)
    assert FileUtils.compare_file(file1, file2), "Files #{file1} and #{file2} are not same."
  end
end
