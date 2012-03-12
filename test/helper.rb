require 'bundler'
require 'minitest/autorun'
require 'fileutils'
require 'tmpdir'

Bundler.setup
require 'letra'

class Letra::TestCase < MiniTest::Unit::TestCase
  attr_accessor :font, :letra, :dir
  def setup
    self.dir   = Dir.mktmpdir('letra')
    self.letra = Letra.new('test/font/font.otf')
    self.letra.destination = dir
  end

  def teardown
    FileUtils.remove_entry_secure self.dir
  end

  private

  def generated_font_path(extension)
    filepath = File.join(dir, "#{letra.name}.#{extension}")
  end

  def assert_generated_file_format(extension, test_with_fontforge = true)
    filepath = generated_font_path(extension)
    assert File.exists?(filepath)
    assert File.size(filepath) > 0
    assert_file_is_valid_font(filepath) if test_with_fontforge
  end

  def assert_not_generated_file_format(extension)
    filepath = generated_font_path(extension)
    assert !File.exists?(filepath)
  end

  def assert_file_is_valid_font(filepath)
    fontforge = RubyPython.import('fontforge')
    assert fontforge.open(filepath)
  end
end
