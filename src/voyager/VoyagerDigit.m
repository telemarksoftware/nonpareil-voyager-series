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
//  VoyagerDigit.m
//  nonpareil
//
//  Created by Maciej Bartosiak on 2005-09-26.
//  Copyright 2005-2012 Maciej Bartosiak.
//

#import "VoyagerDigit.h"

@implementation VoyagerDigit

- (id)initWithDigitHeight: (float) digitH 
					width: (float) digitW 
					share: (float) share
				   stroke: (float) stroke
				dotOffset: (float) dotOff
						x: (float) x
						y: (float) y
{
	NSAffineTransform *tmp;
	
	float digito = 1.0;
	float digitO = digito * 2.0;
	float digith = digitH / 2.0;
	float digits = stroke / 2.0;
	float digitWS = digitW - (stroke * 2.0);
	float digitHS = digith - (stroke * 1.5); // (stroke * 1.5) = stroke + digits 
			
	self = [super init];

/*
	// Original LCD segments by Maciej Bartosiak, but with minus sign modification by Mark H. Shin.  Copyright © 2022 telemark software®

	a = [NSBezierPath bezierPath];
	[a moveToPoint:			NSMakePoint(            digito, digitH        )];
	[a relativeLineToPoint:	NSMakePoint(  digitW  - digitO,    0.0        )];
	[a relativeLineToPoint:	NSMakePoint( -stroke          ,-stroke        )];
	[a relativeLineToPoint:	NSMakePoint( -digitWS + digitO,    0.0        )];
	[a closePath];

	//printf("a: M%f %f l%f %f l%f %f l%f %f Z\n",digito, digitH,digitW  - digitO,    0.0, -stroke          ,-stroke,-digitWS + digitO,    0.0);

	b = [NSBezierPath bezierPath];
	[b moveToPoint:			NSMakePoint(            digitW, digitH  - digito)];
	[b relativeLineToPoint:	NSMakePoint(               0.0,-digith  + digitO)];
	[b relativeLineToPoint:	NSMakePoint(          -stroke , digits          )];
	[b relativeLineToPoint:	NSMakePoint(               0.0, digitHS - digitO)];
	[b closePath];

	//printf("b: M%f %f l%f %f l%f %f l%f %f Z\n",digitW, digitH  - digito,0.0,-digith  + digitO, -stroke , digits,0.0, digitHS - digitO);

	c = [b copy];
	tmp = [NSAffineTransform transform];
	[tmp translateXBy: 0.0 yBy: digitH];
	[tmp scaleXBy: 1.0 yBy: -1.0];
	[c transformUsingAffineTransform: tmp];

	d = [a copy];
	tmp = [NSAffineTransform transform];
	[tmp translateXBy: 0.0 yBy: digitH];
	[tmp scaleXBy: 1.0 yBy: -1.0];
	[d transformUsingAffineTransform: tmp];

	e = [b copy];
	tmp = [NSAffineTransform transform];
	[tmp translateXBy: digitW yBy: digitH];
	[tmp scaleXBy: -1.0 yBy: -1.0];
	[e transformUsingAffineTransform: tmp];

	f = [c copy];
	tmp = [NSAffineTransform transform];
	[tmp translateXBy: digitW yBy: digitH];
	[tmp scaleXBy: -1.0 yBy: -1.0];
	[f transformUsingAffineTransform: tmp];

	g = [NSBezierPath bezierPath];
	[g moveToPoint:			NSMakePoint(           digito, digith)];
	[g relativeLineToPoint:	NSMakePoint( stroke          , digits)];
	[g relativeLineToPoint:	NSMakePoint( digitWS - digitO,    0.0)];
	[g relativeLineToPoint:	NSMakePoint( stroke          ,-digits)];
	[g relativeLineToPoint:	NSMakePoint(-stroke          ,-digits)];
	[g relativeLineToPoint:	NSMakePoint(-digitWS + digitO,    0.0)];
	[g closePath];

	//printf("g: M%f %f l%f %f l%f %f l%f %f l%f %f l%f %f Z\n",digito, digith,stroke          , digits, digitWS - digitO,    0.0,stroke          ,-digits, -stroke          ,-digits, -digitWS + digitO,    0.0);

	// "dot" segment
	h = [NSBezierPath bezierPath];
	[h moveToPoint:			NSMakePoint(   digitW+dotOff,    0.0)];
	[h relativeLineToPoint:	NSMakePoint(             0.0, stroke)];
	[h relativeLineToPoint:	NSMakePoint(          stroke,    0.0)];
	[h relativeLineToPoint:	NSMakePoint(             0.0,-stroke)];
	[h closePath];

	//printf("h: M%f %f l%f %f l%f %f l%f %f Z\n",digitW+dotOff,    0.0,0.0, stroke, stroke,    0.0,0.0, -stroke);

	// "," segment
	i = [NSBezierPath bezierPath];
	[i moveToPoint:			NSMakePoint(  digitW + dotOff,  -digito)];
	[i relativeLineToPoint:	NSMakePoint(           stroke,      0.0)];
	[i relativeLineToPoint:	NSMakePoint(          -stroke,  -stroke)];
	[i relativeLineToPoint:	NSMakePoint(      -stroke/2.0,      0.0)];
	[i closePath];
	
	//printf("i: M%f %f l%f %f l%f %f l%f %f Z\n",digitW + dotOff,  -digito,stroke,      0.0, -stroke,  -stroke,-stroke/2.0,      0.0);

	// "-" Sign segment.  Added by Mark H. Shin.  Copyright © 2022 telemark software®
	s = [NSBezierPath bezierPath];
	[s moveToPoint:            NSMakePoint( digito + stroke, digith)];
	[s relativeLineToPoint:    NSMakePoint(             0.0, digits)];
	[s relativeLineToPoint:    NSMakePoint( digitW - stroke,    0.0)];
	[s relativeLineToPoint:    NSMakePoint(             0.0,-digits)];
	[s relativeLineToPoint:    NSMakePoint(             0.0,-digits)];
	[s relativeLineToPoint:    NSMakePoint(-digitW + stroke,    0.0)];
	[s closePath];

	//printf("g: M%f %f l%f %f l%f %f l%f %f l%f %f l%f %f Z\n",digito + stroke,digith, 0.0,digits, digitW - digits,0.0, 0.0,-digits, 0.0,-digits, -digitW + digits,0.0);

	tmp = [NSAffineTransform transform];
	[tmp shearXBy: share]; 
	//[tmp translateXBy:DIGIT_OFF/2.0 yBy:0.0];

	[tmp translateXBy: x yBy: y];
	[a transformUsingAffineTransform: tmp];
	[b transformUsingAffineTransform: tmp];
	[c transformUsingAffineTransform: tmp];
	[d transformUsingAffineTransform: tmp];
	[e transformUsingAffineTransform: tmp];
	[f transformUsingAffineTransform: tmp];
	[g transformUsingAffineTransform: tmp];
	[h transformUsingAffineTransform: tmp];
	[i transformUsingAffineTransform: tmp];
	[s transformUsingAffineTransform: tmp];                         // Added by Mark H. Shin.  Copyright © 2022 telemark software®
*/

	// +
	// The actual (from engineering drawing) Bezier paths of the original Voyager Series LCD segments with 5° shear angle!  Added by Mark H. Shin.  Copyright © 2022 telemark software®
	// -
	float dx = 2.0;
	float dy = 0.0;
	float dd = 1.0;
	float ds = 3.0;

	// a Segment
	a = [NSBezierPath bezierPath];
	[a moveToPoint: NSMakePoint(15.18 + dx, 24.83 + dy)];
	[a lineToPoint: NSMakePoint(11.31 + dx, 20.99 + dy)];
	[a lineToPoint: NSMakePoint(11.06 + dx, 21.07 + dy)];
	[a lineToPoint: NSMakePoint(10.82 + dx, 21.1 + dy)];
	[a lineToPoint: NSMakePoint(6.41 + dx, 21.1 + dy)];
	[a lineToPoint: NSMakePoint(6.17 + dx, 21.07 + dy)];
	[a lineToPoint: NSMakePoint(5.92 + dx, 20.99 + dy)];
	[a lineToPoint: NSMakePoint(5.71 + dx, 20.88 + dy)];
	[a lineToPoint: NSMakePoint(5.51 + dx, 20.72 + dy)];
	[a lineToPoint: NSMakePoint(1.89 + dx, 24.46 + dy)];
	[a lineToPoint: NSMakePoint(2.02 + dx, 24.61 + dy)];
	[a lineToPoint: NSMakePoint(2.18 + dx, 24.76 + dy)];
	[a lineToPoint: NSMakePoint(2.36 + dx, 24.86 + dy)];
	[a lineToPoint: NSMakePoint(2.55 + dx, 24.94 + dy)];
	[a lineToPoint: NSMakePoint(2.76 + dx, 24.97 + dy)];
	[a lineToPoint: NSMakePoint(14.54 + dx, 24.97 + dy)];
	[a lineToPoint: NSMakePoint(14.76 + dx, 24.96 + dy)];
	[a lineToPoint: NSMakePoint(14.98 + dx, 24.91 + dy)];
	[a lineToPoint: NSMakePoint(15.18 + dx, 24.83 + dy)];
	[a closePath];

	// b Segment
	b = [NSBezierPath bezierPath];
	[b moveToPoint: NSMakePoint(15.98 + dx, 23.72 + dy)];
	[b lineToPoint: NSMakePoint(16 + dx, 23.46 + dy)];
	[b lineToPoint: NSMakePoint(15.62 + dx, 14.78 + dy)];
	[b lineToPoint: NSMakePoint(14.21 + dx, 13.89 + dy)];
	[b lineToPoint: NSMakePoint(14 + dx, 13.89 + dy)];
	[b lineToPoint: NSMakePoint(11.8 + dx, 15.46 + dy)];
	[b lineToPoint: NSMakePoint(12.04 + dx, 19.81 + dy)];
	[b lineToPoint: NSMakePoint(12.02 + dx, 20.09 + dy)];
	[b lineToPoint: NSMakePoint(11.94 + dx, 20.35 + dy)];
	[b lineToPoint: NSMakePoint(11.8 + dx, 20.59 + dy)];
	[b lineToPoint: NSMakePoint(15.67 + dx, 24.43 + dy)];
	[b lineToPoint: NSMakePoint(15.82 + dx, 24.22 + dy)];
	[b lineToPoint: NSMakePoint(15.93 + dx, 23.97 + dy)];
	[b lineToPoint: NSMakePoint(15.98 + dx, 23.72 + dy)];
	[b closePath];

	// c Segment
	c = [NSBezierPath bezierPath];
	[c moveToPoint: NSMakePoint(15.28 + dx, 11.68 + dy)];
	[c lineToPoint: NSMakePoint(13.96 + dx, 1.23 + dy)];
	[c lineToPoint: NSMakePoint(13.94 + dx, 1.14 + dy)];
	[c lineToPoint: NSMakePoint(13.87 + dx, 1.06 + dy)];
	[c lineToPoint: NSMakePoint(13.79 + dx, 1.02 + dy)];
	[c lineToPoint: NSMakePoint(13.7 + dx, 1.01 + dy)];
	[c lineToPoint: NSMakePoint(13.63 + dx, 1.04 + dy)];
	[c lineToPoint: NSMakePoint(13.55 + dx, 1.09 + dy)];
	[c lineToPoint: NSMakePoint(10.11 + dx, 4.53 + dy)];
	[c lineToPoint: NSMakePoint(10.29 + dx, 4.66 + dy)];
	[c lineToPoint: NSMakePoint(10.45 + dx, 4.81 + dy)];
	[c lineToPoint: NSMakePoint(10.56 + dx, 4.99 + dy)];
	[c lineToPoint: NSMakePoint(10.64 + dx, 5.2 + dy)];
	[c lineToPoint: NSMakePoint(10.69 + dx, 5.41 + dy)];
	[c lineToPoint: NSMakePoint(11.37 + dx, 10.87 + dy)];
	[c lineToPoint: NSMakePoint(13.91 + dx, 12.34 + dy)];
	[c lineToPoint: NSMakePoint(14.22 + dx, 12.34 + dy)];
	[c lineToPoint: NSMakePoint(15.28 + dx, 11.68 + dy)];
	[c closePath];

	// d Segment
	d = [NSBezierPath bezierPath];
	[d moveToPoint: NSMakePoint(9.4 + dx, 4.35 + dy)];
	[d lineToPoint: NSMakePoint(13.27 + dx, 0.46 + dy)];
	[d lineToPoint: NSMakePoint(1.48 + dx, 0.46 + dy)];
	[d lineToPoint: NSMakePoint(1.2 + dx, 0.5 + dy)];
	[d lineToPoint: NSMakePoint(0.93 + dx, 0.57 + dy)];
	[d lineToPoint: NSMakePoint(0.68 + dx, 0.7 + dy)];
	[d lineToPoint: NSMakePoint(0.46 + dx, 0.88 + dy)];
	[d lineToPoint: NSMakePoint(4.34 + dx, 4.76 + dy)];
	[d lineToPoint: NSMakePoint(4.53 + dx, 4.58 + dy)];
	[d lineToPoint: NSMakePoint(4.75 + dx, 4.45 + dy)];
	[d lineToPoint: NSMakePoint(5 + dx, 4.37 + dy)];
	[d lineToPoint: NSMakePoint(5.26 + dx, 4.35 + dy)];
	[d lineToPoint: NSMakePoint(9.4 + dx, 4.35 + dy)];
	[d closePath];

	// e Segment
	e = [NSBezierPath bezierPath];
	[e moveToPoint: NSMakePoint(4.28 + dx, 11.17 + dy)];
	[e lineToPoint: NSMakePoint(4.03 + dx, 5.61 + dy)];
	[e lineToPoint: NSMakePoint(4.06 + dx, 5.36 + dy)];
	[e lineToPoint: NSMakePoint(0.12 + dx, 1.43 + dy)];
	[e lineToPoint: NSMakePoint(0.04 + dx, 1.7 + dy)];
	[e lineToPoint: NSMakePoint(0.03 + dx, 1.99 + dy)];
	[e lineToPoint: NSMakePoint(0.45 + dx, 11.85 + dy)];
	[e lineToPoint: NSMakePoint(1.87 + dx, 12.73 + dy)];
	[e lineToPoint: NSMakePoint(2.09 + dx, 12.73 + dy)];
	[e lineToPoint: NSMakePoint(4.28 + dx, 11.17 + dy)];
	[e closePath];

	// f Segment
	f= [NSBezierPath bezierPath];
	[f moveToPoint: NSMakePoint(5.18 + dx, 20.17 + dy)];
	[f lineToPoint: NSMakePoint(2.11 + dx, 23.33 + dy)];
	[f lineToPoint: NSMakePoint(2.04 + dx, 23.38 + dy)];
	[f lineToPoint: NSMakePoint(1.94 + dx, 23.39 + dy)];
	[f lineToPoint: NSMakePoint(1.86 + dx, 23.38 + dy)];
	[f lineToPoint: NSMakePoint(1.78 + dx, 23.34 + dy)];
	[f lineToPoint: NSMakePoint(1.71 + dx, 23.26 + dy)];
	[f lineToPoint: NSMakePoint(1.69 + dx, 23.19 + dy)];
	[f lineToPoint: NSMakePoint(0.81 + dx, 14.94 + dy)];
	[f lineToPoint: NSMakePoint(1.85 + dx, 14.29 + dy)];
	[f lineToPoint: NSMakePoint(2.16 + dx, 14.29 + dy)];
	[f lineToPoint: NSMakePoint(4.71 + dx, 15.75 + dy)];
	[f lineToPoint: NSMakePoint(5.18 + dx, 20.17 + dy)];
	[f lineToPoint: NSMakePoint(5.18 + dx, 20.17 + dy)];
	[f closePath];

	// g Segment
	g = [NSBezierPath bezierPath];
	[g moveToPoint: NSMakePoint(14 + dx, 13.12 + dy)];
	[g lineToPoint: NSMakePoint(10.97 + dx, 11.37 + dy)];
	[g lineToPoint: NSMakePoint(5.08 + dx, 11.37 + dy)];
	[g lineToPoint: NSMakePoint(2.09 + dx, 13.52 + dy)];
	[g lineToPoint: NSMakePoint(5.11 + dx, 15.25 + dy)];
	[g lineToPoint: NSMakePoint(11 + dx, 15.25 + dy)];
	[g lineToPoint: NSMakePoint(14 + dx, 13.12 + dy)];
	[g lineToPoint: NSMakePoint(14 + dx, 13.12 + dy)];
	[g closePath];

	// h Segment
	h = [NSBezierPath bezierPath];
	[h moveToPoint: NSMakePoint(16.73 + dx + dd, 3.74 + dy)];
	[h lineToPoint: NSMakePoint(16.59 + dx + dd, 2.05 + dy)];
	[h lineToPoint: NSMakePoint(16.59 + dx + dd, 1.81 + dy)];
	[h lineToPoint: NSMakePoint(16.63 + dx + dd, 1.56 + dy)];
	[h lineToPoint: NSMakePoint(16.7 + dx + dd, 1.34 + dy)];
	[h lineToPoint: NSMakePoint(16.82 + dx + dd, 1.13 + dy)];
	[h lineToPoint: NSMakePoint(16.96 + dx + dd, 0.93 + dy)];
	[h lineToPoint: NSMakePoint(17.14 + dx + dd, 0.78 + dy)];
	[h lineToPoint: NSMakePoint(17.35 + dx + dd, 0.64 + dy)];
	[h lineToPoint: NSMakePoint(17.57 + dx + dd, 0.55 + dy)];
	[h lineToPoint: NSMakePoint(17.8 + dx + dd, 0.48 + dy)];
	[h lineToPoint: NSMakePoint(18.05 + dx + dd, 0.46 + dy)];
	[h lineToPoint: NSMakePoint(19.76 + dx + dd, 0.46 + dy)];
	[h lineToPoint: NSMakePoint(20.02 + dx + dd, 0.48 + dy)];
	[h lineToPoint: NSMakePoint(20.29 + dx + dd, 0.56 + dy)];
	[h lineToPoint: NSMakePoint(20.52 + dx + dd, 0.69 + dy)];
	[h lineToPoint: NSMakePoint(20.74 + dx + dd, 0.84 + dy)];
	[h lineToPoint: NSMakePoint(20.92 + dx + dd, 1.05 + dy)];
	[h lineToPoint: NSMakePoint(21.06 + dx + dd, 1.28 + dy)];
	[h lineToPoint: NSMakePoint(21.16 + dx + dd, 1.52 + dy)];
	[h lineToPoint: NSMakePoint(21.22 + dx + dd, 1.8 + dy)];
	[h lineToPoint: NSMakePoint(21.36 + dx + dd, 3.49 + dy)];
	[h lineToPoint: NSMakePoint(21.36 + dx + dd, 3.73 + dy)];
	[h lineToPoint: NSMakePoint(21.32 + dx + dd, 3.98 + dy)];
	[h lineToPoint: NSMakePoint(21.24 + dx + dd, 4.2 + dy)];
	[h lineToPoint: NSMakePoint(21.12 + dx + dd, 4.41 + dy)];
	[h lineToPoint: NSMakePoint(20.98 + dx + dd, 4.61 + dy)];
	[h lineToPoint: NSMakePoint(20.8 + dx + dd, 4.76 + dy)];
	[h lineToPoint: NSMakePoint(20.6 + dx + dd, 4.9 + dy)];
	[h lineToPoint: NSMakePoint(20.38 + dx + dd, 4.99 + dy)];
	[h lineToPoint: NSMakePoint(20.14 + dx + dd, 5.06 + dy)];
	[h lineToPoint: NSMakePoint(19.9 + dx + dd, 5.08 + dy)];
	[h lineToPoint: NSMakePoint(18.19 + dx + dd, 5.08 + dy)];
	[h lineToPoint: NSMakePoint(17.92 + dx + dd, 5.06 + dy)];
	[h lineToPoint: NSMakePoint(17.66 + dx + dd, 4.98 + dy)];
	[h lineToPoint: NSMakePoint(17.41 + dx + dd, 4.85 + dy)];
	[h lineToPoint: NSMakePoint(17.21 + dx + dd, 4.7 + dy)];
	[h lineToPoint: NSMakePoint(17.03 + dx + dd, 4.49 + dy)];
	[h lineToPoint: NSMakePoint(16.89 + dx + dd, 4.26 + dy)];
	[h lineToPoint: NSMakePoint(16.78 + dx + dd, 4.02 + dy)];
	[h lineToPoint: NSMakePoint(16.73 + dx + dd, 3.75 + dy)];
	[h lineToPoint: NSMakePoint(16.73 + dx + dd, 3.74 + dy)];
	[h closePath];

	// i Segment
	i = [NSBezierPath bezierPath];
	[i moveToPoint: NSMakePoint(20.23 + dx + dd, -0.12 + dy)];
	[i lineToPoint: NSMakePoint(16.07 + dx + dd, -3.86 + dy)];
	[i lineToPoint: NSMakePoint(15.86 + dx + dd, -3.95 + dy)];
	[i lineToPoint: NSMakePoint(15.63 + dx + dd, -3.97 + dy)];
	[i lineToPoint: NSMakePoint(15.4 + dx + dd, -3.94 + dy)];
	[i lineToPoint: NSMakePoint(15.19 + dx + dd, -3.83 + dy)];
	[i lineToPoint: NSMakePoint(15 + dx + dd, -3.69 + dy)];
	[i lineToPoint: NSMakePoint(14.85 + dx + dd, -3.51 + dy)];
	[i lineToPoint: NSMakePoint(14.74 + dx + dd, -3.31 + dy)];
	[i lineToPoint: NSMakePoint(14.72 + dx + dd, -3.14 + dy)];
	[i lineToPoint: NSMakePoint(14.73 + dx + dd, -2.97 + dy)];
	[i lineToPoint: NSMakePoint(16.43 + dx + dd, 0.6 + dy)];
	[i lineToPoint: NSMakePoint(16.63 + dx + dd, 0.38 + dy)];
	[i lineToPoint: NSMakePoint(16.88 + dx + dd, 0.19 + dy)];
	[i lineToPoint: NSMakePoint(17.15 + dx + dd, 0.03 + dy)];
	[i lineToPoint: NSMakePoint(17.43 + dx + dd, -0.08 + dy)];
	[i lineToPoint: NSMakePoint(17.74 + dx + dd, -0.15 + dy)];
	[i lineToPoint: NSMakePoint(18.05 + dx + dd, -0.17 + dy)];
	[i lineToPoint: NSMakePoint(19.77 + dx + dd, -0.17 + dy)];
	[i lineToPoint: NSMakePoint(20.23 + dx + dd, -0.12 + dy)];
	[i closePath];

	// s Segment
	s = [NSBezierPath bezierPath];
	[s moveToPoint: NSMakePoint(14.2 + dx + ds, 15.56 + dy)];
	[s lineToPoint: NSMakePoint(13.85 + dx + ds, 11.22 + dy)];
	[s lineToPoint: NSMakePoint(1.87 + dx + ds, 11.22 + dy)];
	[s lineToPoint: NSMakePoint(2.22 + dx + ds, 15.56 + dy)];
	[s lineToPoint: NSMakePoint(14.2 + dx + ds, 15.56 + dy)];
	[s closePath];

	tmp = [NSAffineTransform transform];
	[tmp translateXBy: x yBy: y];
	[a transformUsingAffineTransform: tmp];
	[b transformUsingAffineTransform: tmp];
	[c transformUsingAffineTransform: tmp];
	[d transformUsingAffineTransform: tmp];
	[e transformUsingAffineTransform: tmp];
	[f transformUsingAffineTransform: tmp];
	[g transformUsingAffineTransform: tmp];
	[h transformUsingAffineTransform: tmp];
	[i transformUsingAffineTransform: tmp];
	[s transformUsingAffineTransform: tmp];							// Added by Mark H. Shin.  Copyright © 2022 telemark software®

	return self;
}

- (id)init
{
	return [self initWithDigitHeight: (float) 25.0 
							   width: (float) 15.0 
							   share: (float) 0.1
							  stroke: (float) 3.5
						   dotOffset: (float) 5.0
								   x: (float) 0.0
								   y: (float) 24.0];
}

- (void) drawDigit: (segment_bitmap_t)dig
{
	if((dig >> 0) & 1) [a fill];
	if((dig >> 1) & 1) [b fill];
	if((dig >> 2) & 1) [c fill];
	if((dig >> 3) & 1) [d fill];
	if((dig >> 4) & 1) [e fill];
	if((dig >> 5) & 1) [f fill];
	if((dig >> 6) & 1) [g fill];
	if((dig >> 7) & 1) [h fill];
	if((dig >> 8) & 1) [i fill];
}

// Added by Mark H. Shin.  Copyright © 2022 telemark software®
// Draw sign of number.  Actual calculator does not actually display segment g as the sign.  Only called for digit 0.
- (void) drawSign: (segment_bitmap_t)dig
{
	if((dig >> 0) & 1) [a fill];
	if((dig >> 1) & 1) [b fill];
	if((dig >> 2) & 1) [c fill];
	if((dig >> 3) & 1) [d fill];
	if((dig >> 4) & 1) [e fill];
	if((dig >> 5) & 1) [f fill];
	if((dig >> 6) & 1) [s fill];
	if((dig >> 7) & 1) [h fill];
	if((dig >> 8) & 1) [i fill];
}

// Added by Mark H. Shin.  Copyright © 2022 telemark software®
// Draw annunciators.
- (void) drawAnnunciator:(segment_bitmap_t)dig : (int)digit
{
	//if (digit == 0)
	//	[battery fill];
	//	[user fill];
	//	[f_shift fill];
	//	[g_shift fill];
}
@end
