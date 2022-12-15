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
//  VoyagerSimulator.m
//  nonpareil
//
//  Created by Maciej Bartosiak on 2005-09-09.
//  Copyright 2005-2012 Maciej Bartosiak
//

#import "VoyagerSimulator.h"
#import <math.h>

@implementation VoyagerSimulator

@synthesize display;

- (id)init
{
	self = [super init];
	
	NSBundle *nonpareilBundle = [NSBundle mainBundle];
	NSString *objFile = [nonpareilBundle pathForResource: NNPR_OBJ ofType:@"obj"];

	cpu = nut_new_processor (NNPR_RAM);
	nut_read_object_file (cpu, [objFile UTF8String]);
	
	// Initialize default display blink state.
	self.displayBlink = [[[[[[[NSApp mainMenu] itemAtIndex:0] submenu] itemAtIndex:2] submenu] itemAtIndex:1] state];

	[self readState];
	lastRun = [NSDate timeIntervalSinceReferenceDate];
	
	return self;
}

- (void)pressKey: (int)key
{
	if (key == -1)
	{
		nut_release_key(cpu);
	} else {
		nut_press_key(cpu, key);
	}
}

- (void)readKeysFrom: (NSMutableArray *) keyQueue
{
	static int delay = 0;
	int key;
	
	if (delay)
		delay--;
	else
	{
		if([keyQueue lastObject])
		{
			key = [[keyQueue lastObject] intValue];
			[keyQueue removeLastObject];

			[self pressKey: key];

			if (key == -1)
			{
				if([keyQueue lastObject])
				{
					key = [[keyQueue lastObject] intValue];
					[keyQueue removeLastObject];
					[self pressKey: key];
					delay = 2;
				}
			}
		}
	}	
}

- (void)executeCycle
{
	NSTimeInterval now = [NSDate timeIntervalSinceReferenceDate];
	int i = (int)round((now - lastRun) * (NNPR_CLOCK / NNPR_WSIZE));
	lastRun = now;
	
	if (i > 5000) i = 5000;
	
	while (i--) {
		nut_execute_instruction(cpu);
	}
	if ([self displayScan])
		[display setNeedsDisplay:YES];
}

typedef struct
{
	int reg;
	int dig;
	int bit;
} voyager_segment_info_t;

- (BOOL)displayScan
{
	voyager_segment_info_t voyager_display_map [11] [10] =
	{	// Temporarily using 10C ROM for testing display...
#ifdef NONPAREIL_10C
		// Added by Mark H. Shin.  Copyright © 2022 telemark software®
		/* Credit:  agarza (Alex Garza <agarza@paxer.net>) on hpmuseum.org forum for the mapping! */
		/* leftmost position has only segment g for a minus */
		/*    a           b           c           d           e           f          g            h           i           j    */	/* ANNUNCIATORS! */
		{{1,  0, 0}, {1,  0, 0}, {1,  0, 0}, {1,  0, 0}, {1,  0, 0}, {1,  0, 0}, {1, 11, 4}, {1,  0, 0}, {1,  0, 0}, {0,  0, 0}},	// no annunciator
		{{1, 10, 8}, {1, 10, 2}, {1, 11, 2}, {1, 11, 8}, {1, 11, 1}, {1, 10, 4}, {1, 10, 1}, {1, 12, 2}, {1, 12, 1}, {0,  0, 0}},	// no annunciator - "*" for low bat in KML, but that's not controllable by the calculator microcode
		{{1,  3, 8}, {1,  3, 2}, {1,  4, 2}, {1, 12, 8}, {1,  4, 1}, {1,  3, 4}, {1,  3, 1}, {1, 13, 2}, {1, 13, 1}, {1, 12, 4}},	// USER annunciator [not used on 10C]
		{{1,  2, 2}, {1,  1, 8}, {1,  2, 8}, {1, 13, 8}, {1,  2, 4}, {1,  2, 1}, {1,  1, 4}, {1,  6, 2}, {1,  6, 1}, {1, 13, 4}},	// f annunciator
		{{1,  7, 2}, {1,  6, 8}, {1,  7, 8}, {1,  4, 8}, {1,  7, 4}, {1,  7, 1}, {1,  6, 4}, {1,  8, 2}, {1,  8, 1}, {1,  4, 4}},	// g annunciator [not used on 10C]
		{{1,  9, 2}, {1,  8, 8}, {1,  9, 8}, {1,  5, 2}, {1,  9, 4}, {1,  9, 1}, {1,  8, 4}, {1,  5, 8}, {1,  5, 4}, {1,  5, 1}},	// BEGIN annunciator [not used on 10C]
		{{0, 13, 2}, {0, 12, 8}, {0, 13, 8}, {0,  1, 8}, {0, 13, 4}, {0, 13, 1}, {0, 12, 4}, {0, 12, 2}, {0, 12, 1}, {0,  1, 4}},	// G annunciator (for GRAD, or overflow on 16C)
		{{0, 11, 2}, {0, 10, 8}, {0, 11, 8}, {0,  2, 2}, {0, 11, 4}, {0, 11, 1}, {0, 10, 4}, {0, 10, 2}, {0, 10, 1}, {0,  2, 1}},	// RAD annunciator
		{{0,  9, 2}, {0,  8, 8}, {0,  9, 8}, {0,  2, 8}, {0,  9, 4}, {0,  9, 1}, {0,  8, 4}, {0,  4, 2}, {0,  4, 1}, {0,  2, 4}},	// D.MY annunciator [not used on 10C]
		{{0,  7, 8}, {0,  7, 2}, {0,  8, 2}, {0,  3, 8}, {0,  8, 1}, {0,  7, 4}, {0,  7, 1}, {0,  3, 2}, {0,  3, 1}, {0,  3, 4}},	// C annunciator (Complex on 15C, Carry on 16C) [not used on 10C]
		{{0,  6, 2}, {0,  5, 8}, {0,  6, 8}, {0,  4, 8}, {0,  6, 4}, {0,  6, 1}, {0,  5, 4}, {0,  5, 2}, {0,  5, 1}, {0,  4, 4}},	// PRGM annunciator
#else
		/* leftmost position has only segment g for a minus */
		{{0,  0, 0}, {0,  0, 0}, {0,  0, 0}, {0,  0, 0}, {0,  0, 0}, {0,  0, 0}, {0, 11, 4}, {0,  0, 0}, {0,  0, 0}, {0,  0, 0}},	// no annunciator
		{{0,  5, 2}, {0,  5, 8}, {0,  4, 8}, {0, 11, 8}, {0,  4, 4}, {0,  5, 1}, {0,  5, 4}, {0,  9, 8}, {0,  9, 4}, {0,  0, 0}},	// no annunciator - "*" for low bat in KML, but that's not controllable by the calculator microcode
		{{0,  6, 8}, {0,  7, 2}, {0,  6, 2}, {0,  4, 2}, {0,  6, 1}, {0,  6, 4}, {0,  7, 1}, {0,  3, 8}, {0,  3, 4}, {0,  4, 1}},	// USER annunciator
		{{0, 12, 8}, {0, 13, 2}, {0, 12, 2}, {0,  3, 2}, {0, 12, 1}, {0, 12, 4}, {0, 13, 1}, {0, 13, 8}, {0, 13, 4}, {0,  3, 1}},	// f annunciator
		{{0,  8, 2}, {0,  8, 8}, {0,  7, 8}, {0,  2, 2}, {0,  7, 4}, {0,  8, 1}, {0,  8, 4}, {0,  9, 2}, {0,  9, 1}, {0,  2, 1}},	// g annunciator
		{{0, 10, 8}, {0, 11, 2}, {0, 10, 2}, {0,  1, 8}, {0, 10, 1}, {0, 10, 4}, {0, 11, 1}, {0,  2, 8}, {0,  2, 4}, {0,  1, 4}},	// BEGIN annunciator
		{{1,  2, 8}, {1,  3, 2}, {1,  2, 2}, {1,  3, 8}, {1,  2, 1}, {1,  2, 4}, {1,  3, 1}, {1,  4, 2}, {1,  4, 1}, {1,  3, 4}},	// G annunciator (for GRAD, or overflow on 16C)
		{{1,  5, 2}, {1,  5, 8}, {1,  4, 8}, {1,  1, 8}, {1,  4, 4}, {1,  5, 1}, {1,  5, 4}, {1,  6, 2}, {1,  6, 1}, {1,  1, 4}},	// RAD annunciator
		{{1,  7, 2}, {1,  7, 8}, {1,  6, 8}, {1,  9, 8}, {1,  6, 4}, {1,  7, 1}, {1,  7, 4}, {1,  9, 2}, {1,  9, 1}, {1,  9, 4}},	// D.MY annunciator
		{{1, 11, 8}, {1, 12, 2}, {1, 11, 2}, {1,  8, 2}, {1, 11, 1}, {1, 11, 4}, {1, 12, 1}, {1,  8, 8}, {1,  8, 4}, {1,  8, 1}},	// C annunciator (Complex on 15C, Carry on 16C)
		{{1, 13, 2}, {1, 13, 8}, {1, 12, 8}, {1, 10, 2}, {1, 12, 4}, {1, 13, 1}, {1, 13, 4}, {1, 10, 8}, {1, 10, 4}, {1, 10, 1}},	// PRGM annunciator
#endif
	};
	voyager_display_reg_t *dsp = cpu->display_chip;

	int digit;
	int segment;
	int vreg, vdig, vbit;

	BOOL need_update = NO;
	display.ann_update = NO;

	for (digit = 0; digit < VOYAGER_DISPLAY_DIGITS; digit++)
	{
		segment_bitmap_t segs = 0;

		if (dsp->enable && ((!dsp->blink) || (dsp->blink_state)))
		{
			for (segment = 0; segment <= 9; segment++)
			{
				vreg = voyager_display_map [digit][segment].reg;
				vdig = voyager_display_map [digit][segment].dig;
				vbit = voyager_display_map [digit][segment].bit;

				if (vbit && (cpu->ram [9 + vreg][vdig] & vbit))
				{
					if (segment < 9)
						segs |= (1 << segment);
					else
						segs |= SEGMENT_ANN;
				}
			}
		}
		// Added by Mark H. Shin.  Copyright © 2022 telemark software®
		// Determine if annunciator has changed.
		if ((display_segments[digit]&SEGMENT_ANN) != (segs&SEGMENT_ANN) && (cpu->kb_state == (keyboard_state_t)KB_IDLE)) {
			//NSLog(@"display_segments[%d]=%d segs=%d cpu->kb_state=%d",digit,display_segments[digit],segs&SEGMENT_ANN,cpu->kb_state);
			//NSLog(@"digit=%d cpu->ram[9 + %d]=%d",digit,vreg,cpu->ram[9 + vreg]);
			display.ann_update = YES;
		}
		// Added by Mark H. Shin.  Copyright © 2022 telemark software®
		// Only update if segs is different from current digit.  *** Not Fully Implemented ***
#if defined(NONPAREIL_12C) || defined(NONPAREIL_12CP) || 1
		if (display_segments[digit] != segs) {
#else
		if ((display_segments[digit] != segs) && (cpu->kb_state == (keyboard_state_t)KB_IDLE)) {
#endif
			need_update = YES;
			display_segments[digit] = segs;
		}
		//NSLog(@"need_update=%d display.ann_update=%d",need_update,display.ann_update);
	}

	if (dsp->blink)
	{
		dsp->blink_count--;
		if (! dsp->blink_count)
		{
			dsp->blink_state ^= 1;
			dsp->blink_count = VOYAGER_DISPLAY_BLINK_DIVISOR;
		}
	}

	return need_update;
}

- (int)displayDigits
{
	return VOYAGER_DISPLAY_DIGITS;
}

- (segment_bitmap_t *)displaySegments
{
	return display_segments;
}

- (bool)awake							// Added by Mark H. Shin.  Copyright © 2022 telemark software®
{
	// cpu->awake always seems to be false.  Return state of the display_chip instead.
	return cpu->display_chip->enable;
}

- (NSString *)calculatorStateFilename {
	NSFileManager *fileManager = [NSFileManager defaultManager];
	NSArray *urls = [fileManager URLsForDirectory:NSApplicationSupportDirectory inDomains:NSUserDomainMask];
	
	if ([urls count] == 0)
		return nil;

	NSString *nonpareilDirPath = [[urls objectAtIndex:0] path];
	nonpareilDirPath = [nonpareilDirPath stringByAppendingPathComponent:@"nonpareil"];
	NSError *error;

	BOOL success = [fileManager createDirectoryAtPath:nonpareilDirPath
						  withIntermediateDirectories:YES
										   attributes:nil
												error:&error];
	if (!success)
		return nil;
	
	return [nonpareilDirPath stringByAppendingPathComponent:NNPR_STATE];
}

- (void)readState
{
	NSDictionary *stateDict = [[NSMutableDictionary alloc] initWithContentsOfFile:[self calculatorStateFilename]];
	if (stateDict == nil) {
#ifdef NONPAREIL_25
		//woodstock_set_ext_flag(cpu,3,true);
#endif
		// First time POWER ON initializations

		// Initialize default key click state.  Added by Mark H. Shin.  Copyright © 2022 telemark software®
		self.keyClick = [[[[[[[NSApp mainMenu] itemAtIndex:0] submenu] itemAtIndex:2] submenu] itemAtIndex:0] state];

		// Initialize default display blink state.  Added by Mark H. Shin.  Copyright © 2022 telemark software®
		self.displayBlink = [[[[[[[NSApp mainMenu] itemAtIndex:0] submenu] itemAtIndex:2] submenu] itemAtIndex:1] state];

		// Set default contrast value.  Added by Mark H. Shin.  Copyright © 2022 telemark software®
		self.contrast = 3;

		return;
	}

	NSUInteger i;

	str2reg(cpu->a, [[stateDict objectForKey:@"a"] UTF8String]);
	str2reg(cpu->b, [[stateDict objectForKey:@"b"] UTF8String]);
	str2reg(cpu->c, [[stateDict objectForKey:@"c"] UTF8String]);
	str2reg(cpu->m, [[stateDict objectForKey:@"m"] UTF8String]);
	str2reg(cpu->n, [[stateDict objectForKey:@"n"] UTF8String]);

	cpu->g[0]			= (digit_t)[[stateDict objectForKey:@"g0"] unsignedIntValue];
	cpu->g[1]			= (digit_t)[[stateDict objectForKey:@"g1"] unsignedIntValue];

	cpu->p				= (digit_t)[[stateDict objectForKey:@"p"] unsignedIntValue];
	cpu->q				= (digit_t)[[stateDict objectForKey:@"q"] unsignedIntValue];

	cpu->q_sel			= (bool)[[stateDict objectForKey:@"q_sel"] boolValue];

	cpu->fo 			= (digit_t)[[stateDict objectForKey:@"fo"] unsignedIntValue];

	cpu->decimal		= (bool)[[stateDict objectForKey:@"decimal"] boolValue];
	cpu->carry			= (bool)[[stateDict objectForKey:@"carry"] boolValue];
	cpu->prev_carry		= (bool)[[stateDict objectForKey:@"prev_carry"] boolValue];

	cpu->prev_tef_last 	= [[stateDict objectForKey:@"prev_tef_last"] intValue];

	cpu->s				= (uint16_t)[[stateDict objectForKey:@"s"] unsignedIntValue];
	cpu->ext_flag		= (uint16_t)[[stateDict objectForKey:@"ext_flag"] unsignedIntValue];

	cpu->pc				= (uint16_t)[[stateDict objectForKey:@"pc"] unsignedIntValue];

	for(i=0; i<STACK_DEPTH; i++)
		cpu->stack[i] 	= (uint16_t)[[[stateDict objectForKey:@"stack"] objectAtIndex: i] unsignedIntValue]; //poprawić i na NSUint

	cpu->cxisa_addr		= (uint16_t)[[stateDict objectForKey:@"cxisa_addr"] unsignedIntValue];
	cpu->inst_state		= (inst_state_t)[[stateDict objectForKey:@"inst_state"] unsignedIntValue];
	cpu->first_word		= (uint16_t)[[stateDict objectForKey:@"first_word"] unsignedIntValue];
	cpu->long_branch_carry  = (bool)[[stateDict objectForKey:@"long_branch_carry"] boolValue];

	//bool key_down;      /* true while a key is down */
	//keyboard_state_t kb_state;
	//int kb_debounce_cycle_counter;
	//int key_buf;        /* most recently pressed key */

	/*cpu->key_down	= (bool)[[stateDict objectForKey:@"key_down"] boolValue];
	cpu->kb_state	= (keyboard_state_t)[[stateDict objectForKey:@"kb_state"] intValue];
	cpu->kb_debounce_cycle_counter = (int)[[stateDict objectForKey:@"kb_debounce_cycle_counter"] intValue];
	cpu->key_buf	= (int)[[stateDict objectForKey:@"key_buf"] intValue];*/

	cpu->awake			= (bool)[[stateDict objectForKey:@"awake"] boolValue];

	//memory

	cpu->ram_addr = (uint16_t)[[stateDict objectForKey:@"ram_addr"] unsignedIntValue];

	for(i=0; i<cpu->max_ram; i++) {
		//if (cpu->ram_exists[i])
			str2reg(cpu->ram[i], [[[stateDict objectForKey:@"memory"] objectAtIndex: i] UTF8String]); //poprawić i na NSUint
	}

	cpu->display_chip->enable		= (bool)[[stateDict objectForKey:@"display_chip->enable"] boolValue];
	cpu->display_chip->blink		= (bool)[[stateDict objectForKey:@"display_chip->blink"] boolValue];
	cpu->display_chip->blink_state	= (bool)[[stateDict objectForKey:@"display_chip->blink_state"] boolValue];
	cpu->display_chip->blink_count	= (int)[[stateDict objectForKey:@"display_chip->blink_count"] intValue];

	// Key Click state.  Added by Mark H. Shin.  Copyright © 2022 telemark software®
	self.keyClick = (bool)[[stateDict objectForKey:@"keyClick"] boolValue];
	[[[[[[[NSApp mainMenu] itemAtIndex:0] submenu] itemAtIndex:2] submenu] itemAtIndex:0] setState:self.keyClick];

	// Display Blink state.  Added by Mark H. Shin.  Copyright © 2022 telemark software®
	self.displayBlink = (bool)[[stateDict objectForKey:@"displayBlink"] boolValue];
	[[[[[[[NSApp mainMenu] itemAtIndex:0] submenu] itemAtIndex:2] submenu] itemAtIndex:1] setState:self.displayBlink];

	// Contrast state.  Added by Mark H. Shin.  Copyright © 2022 telemark software®
	self.contrast = (int)[[stateDict objectForKey:@"displayContrast"] intValue];
}

- (void)saveState
{
	NSMutableDictionary *stateDict = [[NSMutableDictionary alloc] init];
	char tmp[WSIZE+1] ;
	NSUInteger i;

	[stateDict setValue:[NSString stringWithUTF8String:reg2str(tmp, cpu->a)] forKey:@"a"];
	[stateDict setValue:[NSString stringWithUTF8String:reg2str(tmp, cpu->b)] forKey:@"b"];
	[stateDict setValue:[NSString stringWithUTF8String:reg2str(tmp, cpu->c)] forKey:@"c"];
	[stateDict setValue:[NSString stringWithUTF8String:reg2str(tmp, cpu->n)] forKey:@"n"];
	[stateDict setValue:[NSString stringWithUTF8String:reg2str(tmp, cpu->m)] forKey:@"m"];

	[stateDict setValue:[NSNumber numberWithUnsignedInt: cpu->g[0]] forKey:@"g0"];
	[stateDict setValue:[NSNumber numberWithUnsignedInt: cpu->g[1]] forKey:@"g1"];

	[stateDict setValue:[NSNumber numberWithUnsignedInt: cpu->p] forKey:@"p"];
	[stateDict setValue:[NSNumber numberWithUnsignedInt: cpu->q] forKey:@"q"];
	[stateDict setValue:[NSNumber numberWithBool:cpu->q_sel] forKey:@"q_sel"];

	[stateDict setValue:[NSNumber numberWithUnsignedInt: cpu->fo] forKey:@"fo"];

	[stateDict setValue:[NSNumber numberWithBool:cpu->decimal] forKey:@"decimal"];

	[stateDict setValue:[NSNumber numberWithBool:cpu->carry] forKey:@"carry"];
	[stateDict setValue:[NSNumber numberWithBool:cpu->prev_carry] forKey:@"prev_carry"];

	[stateDict setValue:[NSNumber numberWithInt: cpu->prev_tef_last] forKey:@"prev_tef_last"];

	[stateDict setValue:[NSNumber numberWithUnsignedInt: cpu->s] forKey:@"s"];
	[stateDict setValue:[NSNumber numberWithUnsignedInt: cpu->ext_flag] forKey:@"ext_flag"];

	[stateDict setValue:[NSNumber numberWithUnsignedInt: cpu->pc] forKey:@"pc"];

	NSMutableArray *stack = [[NSMutableArray alloc] init];

	for(i=0; i<STACK_DEPTH; i++)
		[stack insertObject: [NSNumber numberWithUnsignedInt: cpu->stack[i]] atIndex:i];

	[stateDict setValue:stack forKey:@"stack"];

	[stateDict setValue:[NSNumber numberWithUnsignedInt: cpu->cxisa_addr] forKey:@"cxisa_addr"];
	[stateDict setValue:[NSNumber numberWithUnsignedInt: cpu->inst_state] forKey:@"inst_state"];
	[stateDict setValue:[NSNumber numberWithUnsignedInt: cpu->first_word] forKey:@"first_word"];
	[stateDict setValue:[NSNumber numberWithBool:cpu->long_branch_carry] forKey:@"long_branch_carry"];

	//bool key_down;      /* true while a key is down */
	//keyboard_state_t kb_state;
	//int kb_debounce_cycle_counter;
	//int key_buf;        /* most recently pressed key */

	/*[stateDict setValue:[NSNumber numberWithBool: cpu->key_down]
				 forKey:@"key_down"];
	[stateDict setValue:[NSNumber numberWithInt: cpu->kb_state]
				 forKey:@"kb_state"];
	[stateDict setValue:[NSNumber numberWithInt: cpu->kb_debounce_cycle_counter]
				 forKey:@"kb_debounce_cycle_counter"];
	[stateDict setValue:[NSNumber numberWithInt: cpu->key_buf]
				 forKey:@"key_buf"];*/

	[stateDict setValue:[NSNumber numberWithBool:cpu->awake] forKey:@"awake"];

	//memory

	[stateDict setValue:[NSNumber numberWithUnsignedInt: cpu->ram_addr] forKey:@"ram_addr"];

	NSMutableArray *memory = [[NSMutableArray alloc] init];

	for(i=0; i<cpu->max_ram; i++)
		[memory insertObject: [NSString stringWithUTF8String:reg2str(tmp, cpu->ram[i])] atIndex:i];

	[stateDict setValue:memory forKey:@"memory"];

	[stateDict setValue:[NSNumber numberWithBool: cpu->display_chip->enable] forKey:@"display_chip->enable"];
	[stateDict setValue:[NSNumber numberWithBool: cpu->display_chip->blink] forKey:@"display_chip->blink"];
	[stateDict setValue:[NSNumber numberWithBool: cpu->display_chip->blink_state] forKey:@"display_chip->blink_state"];
	[stateDict setValue:[NSNumber numberWithInt: cpu->display_chip->blink_count] forKey:@"display_chip->blink_count"];

	// Key Click state
	[stateDict setValue:[NSNumber numberWithBool: self.keyClick] forKey:@"keyClick"];

	// Display Blink state
	[stateDict setValue:[NSNumber numberWithBool: self.displayBlink] forKey:@"displayBlink"];

	// Display Contrast state
	[stateDict setValue:[NSNumber numberWithInt: self.contrast] forKey:@"displayContrast"];

	[stateDict writeToFile:[self calculatorStateFilename] atomically:YES];
}

@end
