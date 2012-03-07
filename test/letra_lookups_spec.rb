# encoding: utf-8
require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Letra::Lookups do
  it "should return lookups hash for given font" do
    # 'aalt' Access All Alternates in Latin lookup 0
    # 'aalt' Access All Alternates in Latin lookup 1
    Letra::Lookups.for('test/fixtures/font.otf').must_equal({'aalt' => 'Access All Alternates in Latin'})
  end
end
