require 'minitest/autorun'
require "./lib/letra"

describe Letra do
  before do
    @letra = Letra.load(:source_file => "test/fonts/font.otf", 
                        :destination => "output", :font_name => 'Metalista')
  end
  
  after do
    File.unlink("output/Metalista.otf") rescue nil
    File.unlink("output/Metalista.woff") rescue nil
    File.unlink("output/Metalista.svg") rescue nil
    File.unlink("output/Metalista.eot") rescue nil
  end
  
  it "should check if source file exists" do
    @letra.source_file.must_equal "test/fonts/font.otf"
  end
  
  it "should return all type of webfonts" do
    @letra.convert!
    files = Dir.entries(@letra.destination)
    files.include?("Metalista.otf").must_equal true
    files.include?("Metalista.ttf").must_equal false
    files.include?("Metalista.afm").must_equal false    
    files.include?("Metalista.woff").must_equal true
    files.include?("Metalista.svg").must_equal true
    files.include?("Metalista.eot").must_equal true    
  end
end