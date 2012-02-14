Letra
===========

Simple otf to woff,svg and eot converter.

Requires the fontforge, ttf2eot in path.

You can specify path to enc file for filtering exported glyphs.

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

Impleneted OpenType features
----------------------------
You can remove this opentype features:

``` ruby
@features = {:kerning => "'kern' Horizontal Kerning in Latin lookup 0",
             :small_caps => "'smcp' Lowercase to Small Capitals lookup 9",
             :all_small_caps => "'c2sc' Capitals to Small Capitals lookup 6",
             :ligatures => "'liga' Standard Ligatures lookup 34",
             :slashed_zero => "'zero' Slashed Zero lookup 38"}
```                 