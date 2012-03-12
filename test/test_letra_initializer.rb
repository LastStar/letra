require 'helper'

class TestLetraInitializer < Letra::TestCase
  def test_letra_set_corrects_vars
    assert_equal 'font', letra.name
    assert_equal dir, letra.destination
  end
end
