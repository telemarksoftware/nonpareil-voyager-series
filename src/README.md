# nonpareil-voyager-series
nonpareil-voyager-series is a set of MacOS applications which simulate the Hewlett-Packard Voyager Series calculators.


# nonpareil for os x
**nonpareil for OS X** is set of applications that simulate some of vintage HP calculators. Version provided
for OS X is based on [nonpareil 0.77 for Linux](http://http://nonpareil.brouhaha.com/) - a micro-assembler
and simulator package written originally for Linux by Eric Smith.

*nonpareil* is made available under the terms of the Free Software Foundation's
[General Public License, Version 2](http://www.gnu.org/licenses/gpl.html).




# Enhancements by Mark H. Shin

I present to you what HP should have done with the Voyager Series for the desktop...




Retina graphics interface created via high resolution rendered images in Photoshop 2022.

Resources used:

Fonts:      HP Calc KBD Prop
            Apple Symbols
            MicroExtendedFLF    (HP Logo )
            Tactic Sans
            Television P01
            Television P02



HP LOGO:
10C
11C
12C
12C Platinum
15C
16C

Individual digits for the HP logos are rendered using "Television" font by AGFA.

C is rendered using "Tactic Sans Extra Extended Black" font by Miller Type.

Use Illustrator to copy the individual digits and letter "C" to created composite.  See HP_keys.ai, which is my study of the posibilities of using the various fonts.  Import into Photoshop and resize as needed.

Voyager Keypad:

"HP Calc Kbd Prop" (HP specific keys + Helvetica) used for all keys & keypad glyphs GTO, STO, EEX, etc.  Need to adjust point size, tracking, baseline shift, etc...  For exact adjustments, refer to the Photoshop file (HP-Voyager-1200-v3.psd).

"HP Calc Kbd Prop" used for all mathematical symbol glyphs, mathematical operators.  Need to adjust point size, tracking, baseline shift, etc...  For exact adjustments, refer to the Photoshop file (HP-Voyager-1200-v3.psd).

"Helvetica Neue LT Std" used for H E W L E T T . P A C K A R D on keypad.  Need to adjust point size, tracking, baseline shift, etc...  For exact adjustments, refer to the Photoshop file (HP-Voyager-1200-v3.psd).

"Apple Symbols" used for line drawing for groupings:  "BONDS", "DEPRECIATION", "CLEAR", "SHOW", "SET COMPL", although these are now include int "HP Calc Kbd Prop", but never made the switch...  Need to adjust point size, tracking, baseline shift, etc...  For exact adjustments, refer to the Photoshop file (HP-Voyager-1200-v3.psd).

Added '-' (minus) glyph to "HP Calc Kbd Prop" font using FontLab (HPCalKbdPro.vfc) project file.
Added 'square root x' glyph to "HP Calc Kbd Prop" font using FontLab (HPCalKbdPro.vfc) project file.
Added 'exchange' (X exchange Y) glyph to "HP Calc Kbd Prop" font using FontLab (HPCalKbdPro.vfc) project file.
Added 'r' (radius) glyph to "HP Calc Kbd Prop" font using FontLab (HPCalKbdPro.vfc) project file.
Added 'w' (weighted mean) glyph to "HP Calc Kbd Prop" font using FontLab (HPCalKbdPro.vfc) project file.
Added line drawing glyphs (from Apple Symbol font) to "HP Calc Kbd Prop" font using FontLab (HPCalKbdPro.vfc) project file.

Voyager LCD segments created via engineering drawing from Kinpo Electronics of the display segments and electrical diagram, imported into Illustrator, modified, and then exported to SVG format file.  The SVG file was normalized to 25px using https://www.svgviewer.dev (Resize facility).  Using the "normalized" (resized) SVG as input to PaintCode.app, the Objective-C code was autogenerated for MacOS environment (see voyager.pcvd).

In my opinion, clumsily writing "12C Platinum", or "Limited Edition" (for the 15C) on the bezel of the calculator was a major faux pas.  My interface for the 12C Platinum is more in line with the traditional HP aesthetic.

41C:

starburst.pcvd contains the normalized starburst segments for the 41C/CV/CX.






