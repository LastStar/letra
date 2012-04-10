import argparse
import fontforge

parser = argparse.ArgumentParser(description='Convert and modifiyng fonts using python Fontforge')
parser.set_defaults(remove_kerning=False,keep_only=False,subs=(),formats=('otf','woff','svg','ttf'))
parser.add_argument('--remove-kerning', '-K', action='store_true')
parser.add_argument('--keep-only', '-O')
parser.add_argument('--subs', '-S', help='apply lookups', nargs='+')
parser.add_argument('--formats', '-T', help='exported formats', nargs='+')
parser.add_argument('--source', '-F', required=True, help='path to font file')
parser.add_argument('--destination', '-D', required=True, help='dir for converted fonts')
parser.add_argument('--name', '-N', required=True, help='font name')

args = parser.parse_args()

font = fontforge.open(args.source)

for lookup in args.subs:
  glyphs = tuple(font.glyphs())
  for glyph in glyphs:
    substitutions = glyph.getPosSub("*")
    for substitution in substitutions:
      if substitution[0].find(lookup) > 0 and substitution[1] == "Substitution":
        font.selection.select(substitution[2])
        font.copy()
        font.selection.select(glyph.glyphname)
        font.paste()

if args.keep_only:
  font.selection.none()
  for character in args.keep_only.decode('utf-8'):
    font.selection.select(("more", ), ord(character))
  font.selection.invert()
  font.clear()

if args.remove_kerning:
  for lookup in font.gpos_lookups:
    if lookup.find("kern"):
      font.removeLookup(lookup)

for format in args.formats:
  font.generate(args.destination + '/' + args.name + '.' + format)
