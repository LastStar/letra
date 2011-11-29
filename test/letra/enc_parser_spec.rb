require File.expand_path('../spec_helper', File.dirname(__FILE__))

describe Letra::EncParser do
  it "should return well parsed ruby array" do
    array = Letra::EncParser.parse(IO.read("test/fixtures/corpulent.enc"))
    array.length.must_equal 382
    array.first.must_equal 1
    array.last.must_equal 382
  end
end

