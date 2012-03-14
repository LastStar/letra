require 'helper'

class TestLetraConvert < Letra::TestCase
  def test_generate_one_format
    letra.generate!(:ttf)
    assert_generated_file_format('ttf')
  end

  def test_generate_all_formats
    letra.generate!([:ttf, :otf, :svg, :eot, :woff])
    assert_generated_file_format('ttf')
    assert_generated_file_format('otf')
    assert_generated_file_format('svg')
    assert_generated_file_format('woff')
    assert_generated_file_format('eot', false)
  end

  def test_generate_eot
    letra.generate!(:eot)
    assert_generated_file_format('eot', false)
    assert_not_generated_file_format('ttf')
  end

  def test_generate_unknown_format
    assert_raises(RuntimeError) {letra.generate!(:abc)}
    assert_not_generated_file_format('abc')
  end
end
