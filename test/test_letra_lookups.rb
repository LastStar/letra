require 'helper'

class TestLetraLookups < Letra::TestCase
  def test_letra_lookups_returns_lookups_array
    # 'aalt' Access All Alternates in Latin lookup 0
    # 'aalt' Access All Alternates in Latin lookup 1
    assert_equal({'aalt' => 'Access All Alternates in Latin'}, letra.lookups)
  end

  def test_font_have_kerning
    assert letra.kerning?
  end

  def test_font_delete_kerning
    letra.remove_kerning!
    refute letra.kerning?
  end

  def test_font_without_kerning
    font = 'test/fonts/font_without_kerning.otf'
    letra = Letra.new(font)
    assert !letra.kerning?
  end

  def test_apply_substitution
    letra.apply_substitution('aalt')
    assert_rendered_text('.', 'test/images/dot.png')
  end
end
