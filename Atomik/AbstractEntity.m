//
//  AbstractEntity.m
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import "AbstractEntity.h"

@implementation AbstractEntity

@synthesize name;
@synthesize graphic;
@synthesize state;
@synthesize direction;
@synthesize visibility;
@synthesize interaction;
@synthesize transition;
@synthesize speed;
@synthesize delay;
@synthesize position;
@synthesize bounds;
@synthesize sensitivity;

- (id)initWithImage:(Image*)image atPoint:(CGPoint)point {
	self = [super init];
	if (self != nil) {
        [self setName:[NSString stringWithFormat:@"Entity_%@_%f", [image description], RANDOM_MINUS_1_TO_1()]];
        [self setGraphic:image];
		[self setState:kEntity_Idle];
        [self setDirection:kDirection_None];
        [self setVisibility:kVisibility_Show];
        [self setInteraction:kInteraction_None];
        [self setSpeed:0.0f];
        [self setDelay:0.0f];
        [self setPosition:point];
        [self setSensitivity:0.0f];
	}
	return self;
}

- (void)updateBounds {
    float scale = 1.0f;
    if([graphic isRetina]) {
        scale = 2.0f;
    }
        
    
    float left = position.x - (([graphic imageWidth] / scale) / 2.0f);
    float bottom = position.y - (([graphic imageHeight] / scale) / 2.0f);
    
    left -= sensitivity;
    bottom -= sensitivity;
    
    float newWidth = ([graphic imageWidth] / scale) + (sensitivity * 2.0f);
    float newHeight = ([graphic imageHeight] / scale) + (sensitivity * 2.0f);
    
    [self setBounds:CGRectMake(left, bottom, newWidth, newHeight)];
}

- (void)update:(float)delta {
	// Delegate the updates to the sub-classes of this abstract entity.
}

- (void)render {
	// Delegate the rendering process of each entitiy to sub-classes.
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // Delegate the touches process to each entity sub-class.
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // Delegate the touches process to each entity sub-class.
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // Delegate the touches process to each entity sub-class.
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // Delegate the touches process to each entity sub-class.
}

- (void)dealloc {
	[super dealloc];
    /*
    if(graphic != nil) {
        [graphic release];
    }
    */
}

@end
