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
  end

  def assert_not_generated_file_format(extension)
    filepath = generated_font_path(extension)
    assert !File.exists?(filepath), "#{filepath} exists, but should not!"
  end
end
