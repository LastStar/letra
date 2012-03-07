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
1b - Config letra for advanced converting

```ruby
@letra = Letra.load(:source_file => "test/fixtures/font.otf", #source font
                    :glyph_indices => {:languages => ['Czech', 'Slovak'], #filter glyphs for language sets (prepared in encs/languages)
                    :custom_characters => '☃û'}, # add some custom characters to export
                    :destination => "output", #destiantion dir
                    :font_name => 'Metalista', #exported file name
                    :export_to => [:woff, :svg, :eot, :otf], #formats to export (http://en.wikipedia.org/wiki/FontForge#Supported_font_formats)
                    :without => [:kerning], #remove opentype feature
                    :suffix_for_numbers => '.LF') #replace numbers with specified suffix
```
2 - Convert

```ruby                      
@letra.convert!                        
```
3 - Suprise in output directory

Looking for font lookups
----------------------------

``` ruby
Letra::Lookups.for('test/fixtures/font.otf') #=> {'aalt' => 'Access All Alternates in Latin'}
```                 