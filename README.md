Letra
===========

Simple otf to woff,svg and eot converter.

Requires the fontforge, ttf2eot in path.


Example
-------
1 - Config letra and convert

    @letra = Letra.load(:source_file => "test/fonts/font.otf", 
                        :destination => "output", :font_name => 'Metalista')
    @letra.convert!                        

2 - See suprise in output directory