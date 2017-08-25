//
//  AbstractSpawnpod.m
//
//  Created by James Bishop on 7/15/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "AbstractSpawnpod.h"

@implementation AbstractSpawnpod

@synthesize podID;
@synthesize depth;
@synthesize type;

- (id)initAtPoint:(CGPoint)point {
	self = [super init];
	if (self != nil) {
        // Nothing this is the default constructor
        next = 0.0f;
	}
	return self;
}

- (void)open {
    
}

- (void)fire {
    // We have initiated a call to the spawn pod fire routine, so
    // we need to create a new entity and add it to the game
    // pipeline, so that it gets launched into the game system.
}

- (BOOL)isReady {
    return NO;
}


@end
