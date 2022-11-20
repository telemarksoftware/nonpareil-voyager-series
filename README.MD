## Introduction

This repository is the home of Nonpareil Voyager Series.  A simulation of the Hewlett-Packard Voyager Series calculators for the macOS desktop.

This repository is comprised of the macOS Universal Binaries only.  Minimum macOS version is 10.9.

## Acknowlegements

Hewlett-Packard Voyager Series, Retina Graphics Interface & Enhancements, Copyright © 2022 Mark H. Shin, All Rights Reserved.

This work is based on Nonpareil 0.77 for Linux, (Copyright 2004-2006 Eric Smith), the original developer of Nonpareil.

Additionally, the work of Maciej Bartosiak who originally ported Nonpareil to the Mac desktop, based on nonpareil for MacOS (Copyright 2005-2012 Maciej Bartosiak).

Significant assistance by Alex Garza of the HP Museum Forum, who provided the HP-10C segment map.

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

The display's digit segments and punctuations are drawn using Bezier paths and distributed across the display.  In the code, the Bezier segment paths are filled as required to render each digit and punctuation.

The annunciators are drawn as text using HP Helvetica font.

The shape of the digits are derived directly from an engineering drawing of the HP Voyager display.
```
Kinpo Electronics, Inc. BF12A LCD Engineering Drawing
```
![alt text](./assets/kinpo-display.png)

Notes:  Apparently, this was an early draft in the process of final approval.  If you look closely, the annunicators are positioned slight off, compared to the original.

## Get Up & Running

Download the desired calculator release, and unpackage.

## Implementation

Xcode XIB user interface with C and Objective-C language.

## Some usage notes

The first time the calculator is run, you will need to turn it on using the ON button.  "Pr Error" should be displayed indicating continous memory has been reset.  Subsequent restarts will load continous memory and state.

Input via the numeric keypad is supported.

The 'O' key can be used as the ON key.
The ',' key can be used to switch digit separator.
The '.' key can be used to switch digit separator.

Additional options are:
```
Command K
```
Toggle button press sound.
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