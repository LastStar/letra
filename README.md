Letra
===========

Simple otf to woff,svg and eot converter.

Requires the fontforge, ttf2eot in path.

You can specify path to enc file for filtering exported glyphs via Letra.load :glyph_indices parameter.

Example
-------
1a - Config letra for export whole font

    @letra = Letra.load(:source_file => "test/fixtures/font.otf", 
                        :destination => "output", :font_name => 'Metalista')
                        
1b - Config letra for export only selected glyphs

    @letra = Letra.load(:source_file => "test/fixtures/font.otf",
                        :glyph_indices => "test/fixtures/corpulent.enc",
                        :destination => "output", :font_name => 'Metalista')
                        
2 - Convert
                        
    @letra.convert!                        

3 - Suprise in output directory