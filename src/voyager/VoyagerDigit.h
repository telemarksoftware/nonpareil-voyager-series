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
//  VoyagerDigit.h
//  nonpareil
//
//  Created by Maciej Bartosiak on 2005-09-26.
//  Copyright 2005-2012 Maciej Bartosiak. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "NSAffineTransform_Shearing.h"
#import "display.h"

@interface VoyagerDigit : NSObject
{
	NSBezierPath *a;
	NSBezierPath *b;
	NSBezierPath *c;
	NSBezierPath *d;
	NSBezierPath *e;
	NSBezierPath *f;
	NSBezierPath *g;
	NSBezierPath *h;
	NSBezierPath *i;	
    NSBezierPath *s;
	// Annunciators
	NSBezierPath *battery;
	NSBezierPath *user;
	NSBezierPath *f_shift;
	NSBezierPath *g_shift;
	NSBezierPath *begin;
	NSBezierPath *grad;
	NSBezierPath *rad;
	NSBezierPath *dmy;
	NSBezierPath *comp;
	NSBezierPath *prgm;
}

- (id)initWithDigitHeight: (float) digitH 
					width: (float) digitW 
					share: (float) share
				   stroke: (float) stroke
				dotOffset: (float) dotOff
						x: (float) x
						y: (float) y;

- (void) drawDigit: (segment_bitmap_t)dig;

// Added by Mark H. Shin.  Copyright © 2022 telemark software®
- (void) drawSign: (segment_bitmap_t)dig;
- (void) drawAnnunciator: (segment_bitmap_t)dig : (int)digit;
@end
