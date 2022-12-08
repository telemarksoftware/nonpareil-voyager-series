/*
 $Id$
 Copyright 1995, 2003, 2004, 2005 Eric L. Smith <eric@brouhaha.com>
 
 Nonpareil is free software; you can redistribute it and/or modify it
 under the terms of the GNU General Public License version 2 as
 published by the Free Software Foundation.  Note that I am not
 granting permission to redistribute or modify Nonpareil under the
 terms of any later version of the General Public License.
 
 Nonpareil is distributed in the hope that it will be useful, but
 WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program (in the file "COPYING"); if not, write to the
 Free Software Foundation, Inc., 59 Temple Place - Suite 330, Boston,
 MA 02111, USA.
 */

//
//  NonpareilController.h
//  nonpareil
//
//  Created by Maciej Bartosiak on 2005-09-09.
//  Copyright 2005-2012 Maciej Bartosiak
//

#import "VoyagerController.h"

@implementation VoyagerController

#define JIFFY_PER_SEC 30.0

- (void)awakeFromNib
{	
	[NSApp setDelegate:self];
		
	keyQueue = [[NSMutableArray alloc] init];
	
	simulator = [[VoyagerSimulator alloc] init];
	simulator.display = display;
	//[display setupDisplayWith:[simulator displaySegments] count: [simulator displayDigits]];
	[display setupDisplayWith: [simulator displaySegments]
						count: [simulator displayDigits]
					  yOffset: 24.0
				  digitHeight: 25.0
				   digitWidth: 15.0 
				  digitOffset: 10.5
				   digitShare: 0.1
				  digitStroke: 3.5
					dotOffset: 3.5];
	
	// Initialize click sound
	NSString *soundPath = [[NSBundle mainBundle] pathForResource:@"iosClick" ofType:@"m4a"];
	keyClick = [[NSSound alloc] initWithContentsOfFile:soundPath byReference:YES];
	[keyClick setVolume:0.15];

	// Initialize default contrast state.  This connects a bridge from saved state of VoyagerSimulator to VoyagerDisplayView.
	simulator.display.contrast = simulator.contrast;

	timer = [NSTimer scheduledTimerWithTimeInterval:(1.0/JIFFY_PER_SEC)
											  target:self
											selector:@selector(run:)
											userInfo:nil
											 repeats:YES];
}

- (IBAction)buttonPressed:(id)sender
{
	[keyQueue insertObject:[NSNumber numberWithInteger: [sender tag]] atIndex:0];
	[keyQueue insertObject:[NSNumber numberWithInt: -1] atIndex:0];

	// Check status of keyClick and ON state.
	if (simulator.keyClick && [simulator awake])
		[keyClick play];

	// Button is now in the ON state displaying alternate image.  Set timer to reset button state...
	keyTimer = [NSTimer scheduledTimerWithTimeInterval:0.15 target:self selector:@selector(buttonReset:) userInfo:sender repeats: NO];
}

- (void)buttonReset:(NSTimer *)keyTimer
{
	// Get sender (button id) parameter
	id sender = [keyTimer userInfo];

	// Set button state back to off
	[sender setState: NSOffState];

	// Invalidate timer for next button click/tap!
	[keyTimer invalidate];
	keyTimer = nil;
}

- (IBAction)keyClickToggle:(id)sender
{
	simulator.keyClick = !simulator.keyClick;
	[sender setState:simulator.keyClick];
}

- (IBAction)displayBlinkToggle:(id)sender
{
	simulator.displayBlink = !simulator.displayBlink;
	[sender setState:simulator.displayBlink];
}

- (IBAction)contrastPlus:(id)sender
{
	simulator.display.contrast -= 1;
	if (simulator.display.contrast < 0)
		simulator.display.contrast = 0;
	
	if (simulator.contrast != simulator.display.contrast) {
		simulator.contrast = simulator.display.contrast;
		[simulator.display setNeedsDisplay: YES];
	}
}

- (IBAction)contrastMinus:(id)sender
{
	simulator.display.contrast += 1;
	if (simulator.display.contrast > 8)
		simulator.display.contrast = 8;
	
	if (simulator.contrast != simulator.display.contrast) {
		simulator.contrast = simulator.display.contrast;
		[simulator.display setNeedsDisplay: YES];
	}
}

- (void)run:(NSTimer *)aTimer
{
	[simulator readKeysFrom: keyQueue];
	
	[simulator executeCycle];
}

- (void)quit
{
	[timer invalidate];
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
	[simulator saveState];
	[self quit];
}

//--------------------------------------------------------------------------------------------------------
// NSWindow delegate methods
//--------------------------------------------------------------------------------------------------------
- (void)windowDidBecomeKey:(NSNotification *)aNotification
{
	[[aNotification object] setAlphaValue:1.0];
}

- (void)windowDidResignKey:(NSNotification *)aNotification
{
	//[[aNotification object] setAlphaValue:0.85];
}

//- (void)applicationWillTerminate:(NSNotification *)aNotification {
	//[self quit];
//}

@end
