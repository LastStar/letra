# encoding: utf-8
require 'helper'

class TestLetraBlockSyntax < Letra::TestCase
  attr_accessor :font, :letra, :dir
  def setup
    self.dir = Dir.mktmpdir('letra')
  end

  def teardown
    FileUtils.remove_entry_secure self.dir
  end

  def test_letra_block_syntax_with_all
    Letra.open('test/fonts/font.otf') do |font|
      font.destination = self.dir
      font.remove_kerning = true
      font.apply_substitutions = ['aalt']
      font.reduce = 'abcde.!č$?'
      font.formats = [:woff, :eot]
      font.name = 'superfont'
    end

    assert File.exists?(File.join(self.dir, 'superfont.woff'))
    assert File.exists?(File.join(self.dir, 'superfont.eot'))
    refute File.exists?(File.join(self.dir, 'superfont.ttf'))
  end

  def test_letra_block_syntax_with_required
    Letra.open('test/fonts/font.otf') do |font|
      font.destination = self.dir
      font.formats = [:woff, :eot, :ttf]
      font.name = 'superfont'
    end

    assert File.exists?(File.join(self.dir, 'superfont.woff'))
    assert File.exists?(File.join(self.dir, 'superfont.eot'))
    assert File.exists?(File.join(self.dir, 'superfont.ttf'))
  end
end
