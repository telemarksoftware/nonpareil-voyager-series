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
//  VoyagerDisplayView.m
//  nonpareil
//
//  Created by Maciej Bartosiak on 2005-09-09.
//  Copyright 2005-2012 Maciej Bartosiak
//

#import "VoyagerDisplayView.h"

@implementation VoyagerDisplayView

- (id)initWithFrame:(NSRect)frameRect
{
	//NSFont *font;

	if ((self = [super initWithFrame:frameRect]) != nil)
	{
		ds = NULL;
		dc = 0;
		
		attrs = [[NSMutableDictionary alloc] init];
		//[attrs setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];

		// Changed font to Helvetica by Mark H. Shin.  Copyright © 2022 telemark software®
		if (([NSFont fontWithName:@"Helvetica" size:9.0]) != nil)
			[attrs setObject:[NSFont fontWithName:@"Helvetica" size:9.0] forKey:NSFontAttributeName];
		else
			[attrs setObject:[NSFont systemFontOfSize:9.0] forKey:NSFontAttributeName];

		// Added by Mark H. Shin.  Copyright © 2022 telemark software®
		bttrs = [[NSMutableDictionary alloc] init];
		//[bttrs setObject:[NSColor blackColor] forKey:NSForegroundColorAttributeName];
		[bttrs setObject:[NSFont fontWithName:@"Helvetica" size:10.0] forKey:NSFontAttributeName];

		// Added by Mark H. Shin.  Copyright © 2022 telemark software®
		NSShadow *dropShadow = [[NSShadow alloc] init];
		[dropShadow setShadowColor:[NSColor colorWithSRGBRed:0.3686 green:0.4118 blue:0.3490 alpha:0.8]];
		[dropShadow setShadowOffset:NSMakeSize(1.5, -1.5)];
		[dropShadow setShadowBlurRadius:0.0];
		[self setShadow: dropShadow];

		[self setLayerContentsRedrawPolicy: NSViewLayerContentsRedrawCrossfade];
		//[self setLayerContentsRedrawPolicy: NSViewLayerContentsRedrawOnSetNeedsDisplay];
		//[self setLayerContentsRedrawPolicy: NSViewLayerContentsRedrawNever];
	}

	return self;
}

- (BOOL)wantsDefaultClipping {
	return NO;
}

- (void)drawRect:(NSRect)rect
{
	int num;
	
	if (ds == NULL)
		return;
	
	//[[NSColor blackColor] set];

	// Added by Mark H. Shin.  Copyright © 2022 telemark software®
	float rgb = 0.0222*self.contrast;
	// Foreground color for segments
	[[NSColor colorWithSRGBRed:rgb green:rgb blue:rgb alpha:1.0] set];
	// Foreground color for annunciators
	[attrs setObject:[NSColor colorWithSRGBRed:rgb green:rgb blue:rgb alpha:1.0] forKey:NSForegroundColorAttributeName];
	// Foreground color for battery indicator
	[bttrs setObject:[NSColor colorWithSRGBRed:rgb green:rgb blue:rgb alpha:0.75] forKey: NSForegroundColorAttributeName];

	for (num = 0; num < dc; num++)
		if (ds[num]) { // we don't want to draw empty digit
			if (num == 0) {
				// Added by Mark H. Shin.  Copyright © 2022 telemark software®
				[[digits objectAtIndex: num] drawSign:ds[num]];
			} else {
				[[digits objectAtIndex: num] drawDigit:ds[num]];
			}
			//[[digits objectAtIndex: num] drawAnnunciator:ds[num]:num];
		}
	// Now is time for annunciatiors

#define ANNUNC_OFF 7.0
	//[[NSString stringWithUTF8String: "✱"] drawAtPoint: NSMakePoint(21.0,ANNUNC_OFF) withAttributes: bttrs];
	if (ds[1]&SEGMENT_ANN)			// Unicode Heavy Asterisk (U+2731)
		[[NSString stringWithUTF8String: "✱"] drawAtPoint: NSMakePoint(21.0,ANNUNC_OFF) withAttributes: bttrs];
	if (ds[2]&SEGMENT_ANN)
		[[NSString stringWithUTF8String: "USER"] drawAtPoint: NSMakePoint(53.0,ANNUNC_OFF) withAttributes: attrs];
	if (ds[3]&SEGMENT_ANN)
		[[NSString stringWithUTF8String: "f"] drawAtPoint: NSMakePoint(95.0,ANNUNC_OFF) withAttributes: attrs];
	if (ds[4]&SEGMENT_ANN)
		[[NSString stringWithUTF8String: "g"] drawAtPoint: NSMakePoint(111.0,ANNUNC_OFF) withAttributes: attrs];
	if (ds[5]&SEGMENT_ANN)
		[[NSString stringWithUTF8String: "BEGIN"] drawAtPoint: NSMakePoint(128.0,ANNUNC_OFF) withAttributes: attrs];
	if (ds[6]&SEGMENT_ANN)
		[[NSString stringWithUTF8String: "G"] drawAtPoint: NSMakePoint(176.0,ANNUNC_OFF) withAttributes: attrs];
	if (ds[7]&SEGMENT_ANN)
		[[NSString stringWithUTF8String: "RAD"] drawAtPoint: NSMakePoint(183.0,ANNUNC_OFF) withAttributes: attrs];
	if (ds[8]&SEGMENT_ANN)
		[[NSString stringWithUTF8String: "D.MY"] drawAtPoint: NSMakePoint(208.0,ANNUNC_OFF) withAttributes: attrs];
	if (ds[9]&SEGMENT_ANN)
		[[NSString stringWithUTF8String: "C"] drawAtPoint: NSMakePoint(246.0,ANNUNC_OFF) withAttributes: attrs];
	if (ds[10]&SEGMENT_ANN)
		[[NSString stringWithUTF8String: "PRGM"] drawAtPoint: NSMakePoint(266.0,ANNUNC_OFF) withAttributes: attrs];
	
	[self setNeedsDisplay: NO];
}

//- (void)setupDisplayWith:(segment_bitmap_t *)disps count: (int)count
- (void)setupDisplayWith: (segment_bitmap_t *)disps
				   count: (int) count
				 yOffset: (float) y
			 digitHeight: (float) digitHeight
			  digitWidth: (float) digitWidth
			 digitOffset: (float) digitOffset
			  digitShare: (float) digitShare
			 digitStroke: (float) digitStroke
			   dotOffset: (float) dotOffset
{
	VoyagerDigit *dig;
	NSMutableArray *tmp;

	int i;
	float xOff = ([self frame].size.width - ((count) * (digitWidth + digitOffset)))/2.0;	
	dc = count;
	ds = disps;

	tmp = [NSMutableArray arrayWithCapacity: dc];

	for (i = 0; i < dc; i++)
	{
		/*dig = [[VoyagerDigit alloc] initWithDigitHeight: (float) 25.0 
												  width: (float) 15.0 
												  share: (float) 0.1
												 stroke: (float) 3.5
											  dotOffset: (float) 3.0
													  x: (float) xoff
													  y: (float) 24.0];*/
		dig = [[VoyagerDigit alloc] initWithDigitHeight: digitHeight
												  width: digitWidth
												  share: digitShare
												 stroke: digitStroke
											  dotOffset: dotOffset
													  x: xOff
													  y: y];
		[tmp insertObject: dig atIndex: i];
		xOff += (digitWidth + digitOffset);
	}

	digits = [[NSArray alloc] initWithArray: tmp];
}

@end
