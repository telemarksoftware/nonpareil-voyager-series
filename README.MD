## Introduction

This repository is the home of Nonpareil Voyager Series.  A simulation of the Hewlett-Packard Voyager Series calculators for the macOS desktop.

The simulator reads into its simulated ROM memory, the actual original HP microcode of each calculator.  Then the Nut processor is started to begin the calculator simulation.

This repository is comprised of the macOS Universal Binaries only.  Minimum macOS version is 10.9.

This is not a product of Hewlett-Packard or its affiliates.

## Copyright

This repository is free for personal use, but any part, including but not limited to graphic images may not be used or incorporated into any other product for commercial use. 

## Acknowlegements

Hewlett-Packard Voyager Series, Retina Graphics Interface & Enhancements, Copyright © 2022 Mark H. Shin, All Rights Reserved.

This work is based on Nonpareil 0.77 for Linux, by Eric Smith (Copyright 2004-2006 Eric Smith), the original developer of [Nonpareil](https://github.com/brouhaha/nonpareil).

Additionally, the work of Maciej Bartosiak who originally ported Nonpareil to the Mac desktop, based on [nonpareil for MacOS](https://github.com/mbamac/nonpareil) (Copyright 2005-2012 Maciej Bartosiak).

Significant assistance by Alex Garza of the HP Museum Forum, who was kind enough to share his HP-10C display segment map.

## Models

The following Voyager Series models have been implemented:
```
HP-10C Scientific Calculator
```
![alt text](./assets/10c-screen.png)
```
HP-11C Scientific Calculator
```
![alt text](./assets/11c-screen.png)
```
HP-12C Financial Calculator
```
![alt text](./assets/12c-screen.png)
```
HP-15C Scientific Calculator
```
![alt text](./assets/15c-screen.png)
```
HP-16C Computer Scientist
```
![alt text](./assets/16c-screen.png)


## Implementation

The entire keyboard for each calculator was implemented using a self-customized version of the official HP Voyager Series keyboard font.

Keyboard font study in Adobe Illustrator:

![alt text](./assets/keys-study-ai.png)

The display's digit segments and punctuations are drawn using Bezier paths and distributed across the display.  In the code, the Bezier paths are filled as required to render each digit and punctuation.

The annunciators are drawn as text using HP Helvetica font.  It was determined the annunicators would render better at that size using a font rather than filled Bezier paths.

Of note is the low battery indicator, which is never actually displayed in these simulations, looks like the Unicode Heavy Asterisk (U+2731) character in the drawing, but the production models display a distinctly thinner version.

![alt text](./assets/display-lcd.png)

The shape of the digit segments are derived directly from an engineering drawing of the HP Voyager display.
```
Kinpo Electronics, Inc. BF12A LCD Engineering Drawing
```
![alt text](./assets/kinpo-display.png)

Notes:  Apparently, this was an early draft in the process of final approval.  If you look closely, the annunicators are positioned slightly off, compared to the production models.

You'll also notice a very subtle drop shadow for the LCD display segments, and of course working pressed buttons.

## Get Up & Running

Download the desired calculator release, unpackage, and run.

## Development Platform

Xcode XIB user interface, Cocoa Framework with Objective-C and C languages.

## Some usage notes

The first time the calculator is run, you will need to turn it on using the ON button.  "Pr Error" should be displayed indicating continous memory has been reset.  Subsequent restarts will load continous memory and state.

Input via the numeric keypad is supported.
```
The 'O' key can be used as the ON key.
The ',' key can be used to switch digit separator.
The '.' key can be used to switch digit separator.
```
Additional options are:
```
Command K
```
Toggle key click button press sound.
```
Command +
```
Increase LCD display contrast.
```
Command -
```
Decrease LCD display contrast.

## Self-Tests

Pressing 'O' and '*' (on numeric keypad) simultaneously will perform a compelete self-test in which all segments/annunicators should be displayed upon successful completion.

Pressing 'O' and '/' (on numeric keypad) simultaneously will perform the keyboard test in which each key on each row is pressed in succession (Enter key is pressed once for row 3 and again for row 4).  The model number of the calculator should be displayed upon success completion.

Enjoy!

Mark H. Shin

mshin10@hotmail.com

Copyright © 2022 telemark software, llc.  All rights reserved.