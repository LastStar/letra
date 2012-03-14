require 'helper'

class TestLetraUbuntuLookups < Letra::TestCase
  def setup
    self.dir   = Dir.mktmpdir('letra')
    self.letra = Letra.new('test/fonts/ubuntu.ttf')
    self.letra.destination = dir
  end

  def teardown
    self.letra.close
    FileUtils.remove_entry_secure self.dir
  end

  def test_letra_lookups_returns_lookups_array
    lookups = {"locl"=>"Localized Forms in Cyrillic",
      "pnum"=>"Proportional Numbers", "tnum"=>"Tabular Numbers",
      "numr"=>"Numerators", "ordn"=>"Ordinals in Latin",
      "dnom"=>"Denominators", "sups"=>"Superscript",
      "subs"=>"Subscript", "sinf"=>"Scientific Inferiors",
      "frac"=>"Diagonal Fractions", "case"=>"Case-Sensitive Forms",
      "liga"=>"Standard Ligatures in Cyrillic", "ss01"=>"Style Set 1"}
    assert_equal(lookups, letra.lookups)
  end

  def test_apply_substitution
    letra.apply_substitution('case')
    assert_rendered_text('abcd', 'test/images/ubuntu_case.png')
  end

  def test_multiple_substitutions
    letra.apply_substitution('case')
    letra.apply_substitution('numr')
    assert_rendered_text('ab12', 'test/images/ubuntu_case_numr.png')
  end
end
