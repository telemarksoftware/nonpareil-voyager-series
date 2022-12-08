//
//  NSWindow+Resize.h
//  chromifier
//
//  Created by Evadne Wu on 5/6/10.
//  Copyright 2010 Iridia Productions. All rights reserved.
//

#import <Cocoa/Cocoa.h>




@protocol NSWindowResizing

enum NSWindowResizing {

	NSWindowResizeTopLeftCorner = 1,
	NSWindowResizeTopRightCorner = 2,
	NSWindowResizeBottomRightCorner = 3,
	NSWindowResizeBottomLeftCorner = 4
    
};

@end





@interface NSWindow (Resize)

- (void) resizeToWidth:(float)theWidth height:(float)theHeight;
- (void) resizeToWidth:(float)theWidth height:(float)theHeight origin:(int)theOrigin;
- (void) resizeToWidth:(float)theWidth height:(float)theHeight origin:(int)theOrigin duration:(float)theDuration;
- (void) resizeToWidth:(float)theWidth height:(float)theHeight origin:(int)theOrigin duration:(float)theDuration;

@end
