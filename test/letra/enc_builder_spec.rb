# encoding: utf-8
require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe Letra::EncBuilder do
  it "should generate valid enc file for specified languages and custom characters" do
    ids = Letra::EncBuilder.build_enc(:languages => ['Czech', 'Slovak'], :custom_characters => '☃')
    ids.size.must_equal 159
  end

  it "should generate valid enc file for specified languages" do
    ids = Letra::EncBuilder.build_enc(:languages => ['Czech', 'Slovak'])
    ids.size.must_equal 158
  end
end

