//
//  TappableMolecule.m
//  Atomik
//
//  Created by James Bishop on 4/20/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "TappableMolecule.h"

@interface TappableMolecule (Private)

@end

@implementation TappableMolecule

- (id)initWithImage:(Image*)image atPoint:(CGPoint)point {
	self = [super init];
	if (self != nil) {
        [self setGraphic:image];
		[self setState:kEntity_Idle];
        [self setDirection:kDirection_None];
        [self setVisibility:kVisibility_Show];
        [self setInteraction:kInteraction_None];
        [self setSpeed:0.0f];
        [self setRadius:23.0f];
        [self setPosition:point];
        
        [self setUnique:arc4random()];
        [self setScale:1.0f];
        
        [self setSensitivity:5.0f];
        
        [super updateBounds];
        
        vibrateDelta = 0.0f;
        vibrateVarianceX = 0.0f;
        
        tapCount = 0;
	}
	return self;
}

- (void)update:(float)delta {
    // We only want to update the position of the entity if the state
    // is alive, as (dead, dying or idle entites shoud remain stil).
    if(state == kEntity_Alive) {
        if(direction == kDirection_Down) {
            position.y -= ((delta * FRAME_RATE) * speed);
            
        } else if(direction == kDirection_Up) {
            position.y += ((delta * FRAME_RATE) * speed);
            
        } else if(direction == kDirection_Right) {
            position.x += ((delta * FRAME_RATE) * speed);
            
        } else if(direction == kDirection_Left) {
            position.x -= ((delta * FRAME_RATE) * speed);
            
        }
    }
    
    [super updateBounds];
    
    if(state == kEntity_Dying) {
        [explosion update:delta];
        if(![explosion running]) {
            state = kEntity_Dead;
        }
    }
    
    if(tapCount == (STEAMPOD_TAPS - 1)) {
        vibrateDelta += delta;
    
        if(vibrateDelta > VIBRATE_FREQUENCY) {
            vibrateVarianceX = (-1.0f + (RANDOM_0_TO_1() * 2.0f));
            vibrateVarianceY = (-1.0f + (RANDOM_0_TO_1() * 2.0f));
            vibrateDelta = 0.0f;
        }
    
        marker = CGPointMake(position.x + vibrateVarianceX, position.y + vibrateVarianceY);
    }
}

- (BOOL)isDoubleTapped {
    return (tapCount == STEAMPOD_TAPS);
}

- (void)render {
    // Each spawn pod is facing in a different direction, so we
    // must cater for the fact that they fire different directions.
    if(state == kEntity_Alive || state == kEntity_Idle) {
        
        [graphic setRetinaScale:scale];
        if(tapCount == (STEAMPOD_TAPS - 1)) {
            [graphic renderAtPoint:marker centerOfImage:YES];
        } else {
            [graphic renderAtPoint:position centerOfImage:YES];
        }
        
    } else if(state == kEntity_Dying) {
        [explosion renderAtPoint:position scale:scale];
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view{
    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    int height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (height - location.y);
    
    interaction = kInteraction_Tap;
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    int height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (height - location.y);
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    int height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (height - location.y);
    
    interaction = kInteraction_UnTap;
    
    tapCount++;
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(interaction == kInteraction_Drag) {
        interaction = kInteraction_Drop;
        state = kEntity_Alive;
    }
}

@end
