//
//  NSWindow+Resize.m
//  chromifier
//
//  Created by Evadne Wu on 5/6/10.
//  Copyright 2010 Iridia Productions. All rights reserved.
//





#import "NSWindow+Resize.h"


@implementation NSWindow (Resize)


- (void) resizeToWidth:(float)theWidth height:(float)theHeight {

	[self resizeToWidth:theWidth height:theHeight origin:NSWindowResizeBottomLeftCorner];

}





- (void) resizeToWidth:(float)theWidth height:(float)theHeight origin:(int)theOrigin {

	[self resizeToWidth:theWidth height:theHeight origin:theOrigin duration:0.5];

}





- (void) resizeToWidth:(float)theWidth height:(float)theHeight origin:(int)theOrigin duration:(float)theDuration {

	float currentWidth = self.frame.size.width;
	float currentHeight = self.frame.size.height;

	float originX = self.frame.origin.x;
	float originY = self.frame.origin.y;
	
	switch (theOrigin) {
	
		case NSWindowResizeTopLeftCorner:
		
			originY = originY + currentHeight - theHeight;
			
			break;
		
		case NSWindowResizeTopRightCorner:
		
			originY = originY + currentHeight - theHeight;
			originX = originX + currentWidth - theWidth;
		
			break;
			
		case NSWindowResizeBottomRightCorner:
		
			originX = originX + currentWidth - theWidth;
		
			break;
			
		case NSWindowResizeBottomLeftCorner:
		
			//	Does nothing
		
			break;
			
		default:
				
			break;

	}
	
	NSViewAnimation *viewAnimation = [[NSViewAnimation alloc] initWithViewAnimations: [NSArray arrayWithObjects:
	
		[NSDictionary dictionaryWithObjectsAndKeys: 
		
			self, 
			
			NSViewAnimationTargetKey, 
			
			[NSValue valueWithRect:NSMakeRect(
	
				originX,
				originY,
				theWidth, 
				theHeight
			
			)], 
			
			NSViewAnimationEndFrameKey, 
			
		nil],
		
	nil]];

	[viewAnimation setAnimationBlockingMode:NSAnimationBlocking];
	[viewAnimation setDuration:theDuration];

	[viewAnimation startAnimation];
	[viewAnimation release];

}

@end
