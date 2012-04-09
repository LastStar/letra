def apply_substitution(font, lookup):
  glyphs = tuple(font.glyphs())
  for glyph in glyphs:
    substitutions = glyph.getPosSub("*")
    for substitution in substitutions:
      if substitution[0].find(lookup) > 0 and substitution[1] == "Substitution":
        font.selection.select(substitution[2])
        font.copy()
        font.selection.select(glyph.glyphname)
        font.paste()

def glyphs_count(font):
  return len(tuple(font.glyphs()))

def gsub_lookups(font):
  return font.gsub_lookups

