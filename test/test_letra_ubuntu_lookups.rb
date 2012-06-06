require 'helper'

class TestLetraUbuntuLookups < Letra::TestCase
  attr_accessor :font, :letra, :dir
  def setup
    self.dir = Dir.mktmpdir('letra')
  end

  def teardown
    FileUtils.remove_entry_secure self.dir
  end


  def test_apply_substitution
    Letra.open('test/fonts/ubuntu.otf') do |font|
      font.destination = self.dir
      font.apply_substitutions = ['case']
      font.formats = [:otf]
      font.name = 'superfont'
      font.family = 'superfamily'
      font.subtype = 'normal'
      font.unique = 'Unique ID'
      font.copyright = 'Copy'
    end

    assert_rendered_text(generated_font_path('superfont', 'otf'),
                         'abcd', 'test/images/ubuntu_case.png')
  end

  def test_multiple_substitutions
    Letra.open('test/fonts/ubuntu.otf') do |font|
      font.destination = self.dir
      font.apply_substitutions = ['case', 'numr']
      font.formats = [:otf]
      font.name = 'superfont'
      font.family = 'superfamily'
      font.subtype = 'normal'
      font.unique = 'Unique ID'
      font.copyright = 'Copy'
    end

    assert_rendered_text(generated_font_path('superfont', 'otf'),
                         'ab12', 'test/images/ubuntu_case_numr.png')
  end
end
