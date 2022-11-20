## Introduction

This repository is the home of Nonpareil Voyager Series.  A simulation of the Hewlett-Packard Voyager Series calculators for the macOS desktop.

## Copyright

Hewlett-Packard Voyager Series, Retina Graphics Interface & Enhancements, Copyright © 2022 Mark H. Shin

This release is comprised of the macOS Universal Binaries Only.  Minimum macOS version is 10.9.

This work is based on Nonpareil 0.77 for Linux, (Copyright 2004-2006 Eric Smith), the original developer of Nonpareil.

Additionally, the work of Maciej Bartosiak who originally ported Nonpareil to the Mac desktop, based on nonpareil for MacOS (Copyright 2005-2012 Maciej Bartosiak).

## Models

The following models have been implemented:

HP-10C

![alt text](./assets/10c-screen.png)

HP-11C

![alt text](./assets/11c-screen.png)

HP-12C

![alt text](./assets/12c-screen.png)

HP-15C

![alt text](./assets/15c-screen.png)

HP-16C

![alt text](./assets/16c-screen.png)


## Implementation

The display's digit segments and punctuations are drawn using Bezier paths and distributed across the display.  In the code, the Bezier segments are filled as required to render each digit and punctuation.

The annunciators are drawn as text using HP Helvetica font.

The shape of the digits are derived directly fron an engineering drawing of the HP Voyager display.

![alt text](./assets/kinpo-display.png)

Notes:  Apparently, this was an early draft in the process of final approval.  If you look closely, the annunicators are positioned slight off, compared to the original.




The full story can be found on his website:  https://skn.noip.me/pdp11/pdp11.html

His entire archive of the PDP-11/70 and PDP-11/45 can be downloaded from:  https://skn.noip.me/pdp11/pdp11.zip

This Electron app builds on the basis files contained within this zip archive, and therefore are required for this application.

Since Electron is based on Chrome, a full fledge web debugger is automatically included with the application.  You can test this by clicking Command-Option-I on macOS, or Control-Shift-I on Windows systems.

![alt text](./assets/pdp11-developer.png)

For the following discussion, it is assumed the reader has knowledge of Electron, Node, and NPM and also has all three installed on their system...
## Quickstart Tip
Download and install Node.js from the official website.  This installation also installs NPM.  Later, when you install dependencies (see below), electron will automatically be installed as a node module.
```
https://nodejs.org
```
## How does it work?

The app uses the express node module to serve files contained within the pdp11 folder of the Electron application.  This includes the main page pdp11.html, and the OS disk images (*.dsk) within the folder.

Electron starts and initiates express server by listening on TCP/IP port 1170 for the PDP-11/70, or TCP/IP port 1145 for the PDP-11/45.  Electron then loads the URL of the main page via HTTP request to
```
http://localhost:1170/pdp11.html
```
or
```
http://localhost:1145/pdp11-45.html
```
depending on model of mini computer.


## Get Up & Running

Choose your platform and model, then copy the corresponding folder to a destination of your choice.

Unzip the files from the pdp11.zip archive downloaded from Paul Nankervis' website to the pdp11 folder contained within the top level of the Electron application folder.

## *** IMPORTANT ***
Do not overwrite the existing pdp11.html or pdp11-45.html, as these have been modified slightly to allow for the enhancements, such as the Windows 10 title bar, window drag region, and slide down console.

## Exactly what was modified?
Here is the list:

Stylesheet allows for additional formatting control in coordination with electron application.
```
<link rel="stylesheet" href="style.css" type="text/css">
```
Added Windows 10 style title bar on Windows systems.  Original contributor is [Ronnie Dutta](https://github.com/binaryfunt/electron-seamless-titlebar-tutorial).  Updated to IPCRenderer implementation code and drag region support added by yours truly.
```
<div id="titlebar">
    .
    .
    .
</div>
```
Affords better control of the documentation section of the page, allowing the console and documentation to scroll under the main control panel.
```
<div id="thePage" style="margin: 16px; clear:both;">
    .
    .
    .
</div>
```
Clickable area which toggles view of the console/documentation panel.  On macOS, the console tray is animated.  Unfortunately, on Windows, animation has not yet been implemented for Electron.
```
<div id="console"></div>
```
![alt text](./assets/pdp11-console.png)

Disabling of onfocus for console, which shifted the rendered HTML to top of page.
```
//document.getElementById('0').focus();
```

## Implementation

CD into the top level of your destination folder and run the following to install node dependancies:
```
npm install
```
Start the electron application via:
```
npm start
```
To package the electron application using electron-packager, use the provided x64.sh or x64.cmd script.

## Some usage notes

To drag the entire window to another position, simply click-drag the title bar area.  The window position will persist between restarts.

On macOS systems, if you hover your mouse over the upper left corner, the macOS traffic light control buttons will become visible.

On Windows systems, if you hover your mouse over the upper right corner, the Windows 10 title bar style control buttons will become visible.

Hovering the mouse over the lower right of the front panel, the mouse cursor will change indicating that a click will open/close the console panel.

Clicking this area toggles view of the console used to boot the various disk images, and also displays the documentation which can be viewed by scrolling the page.

When first run on Windows, you may get a firewall warning which is to be expected.  Recommend allowing.

If all goes according to plan/instructions, you should have your very own self-contained, working, DEC PDP-11 mini computer available to you on call and on your desktop for your viewing pleasure!

Enjoy!


Copyright © 2022 telemark software, llc.  All rights reserved.