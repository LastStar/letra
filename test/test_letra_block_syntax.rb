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
      font.remove_kerning = true
      font.apply_substitutions = ['aalt']
      font.reduce = 'abcde.'
      font.formats = [:woff, :eot]
      font.name = 'superfont'
    end

    assert File.exists?(File.join(self.dir, 'superfont.woff'))
    assert File.exists?(File.join(self.dir, 'superfont.eot'))
    refute File.exists?(File.join(self.dir, 'superfont.ttf'))
  end
end
