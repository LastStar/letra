# encoding: utf-8
require File.expand_path('spec_helper', File.dirname(__FILE__))

describe Letra do
  before do
  end

  after do
    File.unlink("output/Metalista.otf") rescue nil
    File.unlink("output/Metalista.woff") rescue nil
    File.unlink("output/Metalista.svg") rescue nil
    File.unlink("output/Metalista.eot") rescue nil
  end

  it "should check if source file exists" do
    letra = Letra.load(:source_file => "test/fixtures/font.otf",
                       :destination => "output", :font_name => 'Metalista',
                       :export_to => [:woff, :svg, :eot])
    letra.source_file.must_equal "test/fixtures/font.otf"
  end

  it "should return all type of webfonts" do
    letra = Letra.load(:source_file => "test/fixtures/font.otf",
                       :destination => "output", :font_name => 'Metalista',
                       :export_to => [:woff, :svg, :eot])
    letra.convert!
    files = Dir.entries(letra.destination)
    files.include?("Metalista.otf").must_equal false
    files.include?("Metalista.ttf").must_equal false
    files.include?("Metalista.afm").must_equal false
    files.include?("Metalista.woff").must_equal true
    files.include?("Metalista.svg").must_equal true
    files.include?("Metalista.eot").must_equal true

    File.size("output/Metalista.woff").must_equal 9560
  end

  it "should return only woff" do
    letra = Letra.load(:source_file => "test/fixtures/font.otf",
                       :destination => "output", :font_name => 'Metalista',
                       :export_to => [:woff])
    letra.convert!
    files = Dir.entries(letra.destination)
    files.include?("Metalista.otf").must_equal false
    files.include?("Metalista.ttf").must_equal false
    files.include?("Metalista.afm").must_equal false
    files.include?("Metalista.svg").must_equal false
    files.include?("Metalista.eot").must_equal false
    files.include?("Metalista.woff").must_equal true

    File.size("output/Metalista.woff").must_equal 9560
  end

  it "should return reduces webfonts" do
    letra = Letra.load(:source_file => "test/fixtures/font.otf",
                       :glyph_indices => "test/fixtures/corpulent.enc",
                       :destination => "output", :font_name => 'Metalista',
                       :export_to => [:woff, :svg, :eot])
    letra.convert!

    File.size("output/Metalista.woff").must_equal 7940
    File.size("output/Metalista.svg").must_equal 54541
    File.size("output/Metalista.eot").must_equal 25668
  end


  it "should return reduced webfonts with Czech and Slovak glyphs" do
    letra = Letra.load(:source_file => "test/fixtures/font.otf",
                       :glyph_indices => {:languages => ['Czech', 'Slovak']},
                       :destination => "output", :font_name => 'Metalista',
                       :export_to => [:woff, :svg, :eot])
    letra.convert!

    File.size("output/Metalista.woff").must_equal 5312
    File.size("output/Metalista.svg").must_equal 26681
    File.size("output/Metalista.eot").must_equal 13316
  end


  it "should return reduced webfonts with Czech and Slovak glyphs and custom char" do
    letra = Letra.load(:source_file => "test/fixtures/font.otf",
                       :glyph_indices => {:languages => ['Czech', 'Slovak'], :custom_characters => '☃û'},
                       :destination => "output", :font_name => 'Metalista',
                       :export_to => [:woff, :svg, :eot])
    letra.convert!

    File.size("output/Metalista.woff").must_equal 5352
    File.size("output/Metalista.svg").must_equal 26842
    File.size("output/Metalista.eot").must_equal 13388
  end
end
