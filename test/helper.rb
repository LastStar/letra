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
    self.dir = Dir.mktmpdir('letra')
  end

  def teardown
    FileUtils.remove_entry_secure self.dir
  end

  private

  def generated_font_path(name, extension)
    filepath = File.join(dir, "#{name}.#{extension}")
  end

  def assert_generated_file_format(extension, test_with_fontforge = true)
    filepath = generated_font_path(extension)
    assert File.exists?(filepath), "#{filepath} doesn't exists"
    assert File.size(filepath) > 0, "#{filepath} is empty"
  end

  def assert_not_generated_file_format(extension)
    filepath = generated_font_path(extension)
    assert !File.exists?(filepath), "#{filepath} exists, but should not!"
  end

 def assert_rendered_text(font, text, image)
    renderer = Glyphr::Renderer.new(font, 72)
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
