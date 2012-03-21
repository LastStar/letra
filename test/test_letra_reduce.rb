# encoding: utf-8
require 'helper'

class TestLetraReduce < Letra::TestCase
  def test_reduce_to_numbers
    letra.reduce!('01234567890')
    assert_equal 10, letra.glyphs_count
  end

  def test_reduce_to_five_letters
    letra.reduce!('abcde')
    assert_equal 5, letra.glyphs_count
  end

  def test_reduce_to_symbols
    letra.reduce!('&@{}()')
    assert_equal 6, letra.glyphs_count
  end

  def test_reduce_to_basic_set
    basic_set = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789&@€$¢£¥?!¿¡§%‰*†'\"“”‘’‹›«»#(/)[\]{|}-–—_.,:;©®™ªº^+-×=<>•"
    letra.reduce!(basic_set)
    assert_equal 116, letra.glyphs_count
  end
end
