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
parser.add_argument('--family', '-A', required=True, help='font family')
parser.add_argument('--subtype', '-Y', required=True, help='font type')
parser.add_argument('--unique', '-U', required=True, help='Unique ID')

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

# from https://gitorious.org/suruma/suruma/blobs/master/generate.py
font.selection.all()
font.autoHint()

if 'ttf' in args.formats:
  args.formats.remove('ttf')
  ttf = True

for format in args.formats:
  font.em = 1000
  font.generate(args.destination + '/' + args.name + '.' + format)

if ttf:
  # from https://gitorious.org/suruma/suruma/blobs/master/generate.py
  font.em = 2048
  font.round()

  font.sfnt_names = ()
  font.appendSFNTName('English (US)', 'Family', args.family)
  font.appendSFNTName('English (US)', 'SubFamily', args.subtype)
  font.appendSFNTName('English (US)', 'UniqueID', args.unique)
  font.appendSFNTName('English (US)', 'Fullname', args.family + args.subtype)
  font.appendSFNTName('English (US)', 'PostScriptName', args.family)
  font.appendSFNTName('English (US)', 'Descriptor', args.family + args.subtype)
  font.appendSFNTName('English (US)', 'Compatible Full', args.family + args.subtype)
  font.appendSFNTName('English (US)', 'CID findfont Name', args.name)
  font.os2_fstype = 0
  font.generate(args.destination + '/' + args.name + '.' + 'ttf')

