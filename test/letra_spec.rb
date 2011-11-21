require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Letra do
  before do
    @letra = Letra.load(:source_file => "test/fixtures/font.otf", 
                        :destination => "output", :font_name => 'Metalista')
  end
  
  after do
    File.unlink("output/Metalista.otf") rescue nil
    File.unlink("output/Metalista.woff") rescue nil
    File.unlink("output/Metalista.svg") rescue nil
    File.unlink("output/Metalista.eot") rescue nil
  end
  
  it "should check if source file exists" do
    @letra.source_file.must_equal "test/fixtures/font.otf"
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
    
    File.size("output/Metalista.otf").must_equal 26716
  end
  
  it "should return reduces webfonts" do
    letra = Letra.load(:source_file => "test/fixtures/font.otf",
                       :glyph_indices => "test/fixtures/corpulent.enc",
                       :destination => "output", :font_name => 'Metalista')
    letra.convert!     
    
    File.size("output/Metalista.otf").must_equal 15852
  end
end