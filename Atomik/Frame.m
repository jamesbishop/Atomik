//
//  Frame.m
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import "Frame.h"

@implementation Frame

@synthesize frameDelay;
@synthesize frameImage;

- (id)initWithImage:(Image*)image delay:(float)delay {
	self = [super init];
	if(self != nil) {
		frameImage = image;
		frameDelay = delay;
	}
	return self;
}

- (void)dealloc {
    [frameImage release];
	[super dealloc];
}

@end
