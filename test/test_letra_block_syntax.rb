require 'helper'

class TestLetraBlockSyntax < Letra::TestCase
  attr_accessor :font, :letra, :dir
  def setup
    self.dir = Dir.mktmpdir('letra')
  end

  def teardown
    FileUtils.remove_entry_secure self.dir
  end

  def test_letra_block_syntax
    Letra.open('test/fonts/font.otf') do |font|
      font.destination = self.dir
      font.apply_substitution('aalt')
      font.reduce!('abcde.')
      font.generate!(:woff)
    end

    self.letra = Letra.new(File.join(dir, "font.woff"))
    assert_equal 7, letra.glyphs_count
  end
end
