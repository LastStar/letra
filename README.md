Letra
===========

Simple otf to woff,svg and eot converter.

Requires the fontforge, ttf2eot in path.

You can specify path to enc file for filtering exported glyphs.

Installation
------------

### TTF2EOT

#### BSD, Linux

    wget http://ttf2eot.googlecode.com/files/ttf2eot-0.0.2-2.tar.gz
    tar -xvf ttf2eot-0.0.2-2.tar.gz
    cd ttf2eot-0.0.2-2
    make
    
And copy to $PATH.

If you have some troubles with compiling, read http://code.google.com/p/ttf2eot/issues/detail?id=8#c3.

#### Mac

There is a MacPort - https://trac.macports.org/browser/trunk/dports/print/ttf2eot/Portfile. You can inspire, how to compile.

#### Windows

Go play Solitare!

### FontForge

#### BSD

Install via ports.

#### Linux

Install with package manager.

#### MAC

http://fontforge.sourceforge.net/mac-install.html

Example
-------
1a - Config letra for export whole font

```ruby
@letra = Letra.load(:source_file => "test/fixtures/font.otf", 
                    :destination => "output", :font_name => 'Metalista')
```
1b - Config letra for export only selected glyphs

```ruby
@letra = Letra.load(:source_file => "test/fixtures/font.otf",
                    :glyph_indices => "test/fixtures/corpulent.enc",
                    :destination => "output", :font_name => 'Metalista')
```                       
2 - Convert

```ruby                      
@letra.convert!                        
```
3 - Suprise in output directory