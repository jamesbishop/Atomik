//
//  BasicShape.m
//
//  Created by James Bishop on 5/12/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "DraggableMolecule.h"

@interface DraggableMolecule (Private)

@end

@implementation DraggableMolecule

- (id)initWithImage:(Image*)image atPoint:(CGPoint)point {
	self = [super init];
	if (self != nil) {
        [self setGraphic:image];
		[self setState:kEntity_Idle];
        [self setDirection:kDirection_None];
        [self setVisibility:kVisibility_Show];
        [self setInteraction:kInteraction_None];
        [self setSpeed:0.0f];
        [self setRadius:24.0f];
        [self setPosition:point];
        
        [self setUnique:arc4random()];
        [self setScale:1.0f];
        
        [self setSensitivity:5.0f];
        
        [super updateBounds];
	}
	return self;
}

- (void)update:(float)delta {
    // We only want to update the position of the entity if the state
    // is alive, as (dead, dying or idle entites shoud remain stil).
    if(state == kEntity_Alive && interaction == kInteraction_None) {

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
    
    if(state == kEntity_Idle) {
        if(transition == kTransition_Success) {
            scale -= (delta * 5.0f);
            if(scale < 0.1f) {
                state = kEntity_Dead;
            }
        }
    }
    
    if(state == kEntity_Dying) {
        [explosion update:delta];
        if(![explosion running]) {
            state = kEntity_Dead;
        }
    }
}

- (void)render {
    // Each spawn pod is facing in a different direction, so we
    // must cater for the fact that they fire different directions.
    if(state == kEntity_Alive || state == kEntity_Idle) {
        [graphic setRetinaScale:scale];
        [graphic renderAtPoint:position centerOfImage:YES];
        
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
    
    position.x = location.x;
    position.y = location.y;

    interaction = kInteraction_Drag;

    //NSLog(@"Molecule %d has been DRAGGED (%d) ...", ID, interaction);
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    int height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (height - location.y);
    
    position.x = location.x;
    position.y = location.y;
    
    interaction = kInteraction_Drag;
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    int height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (height - location.y);
    
    position.x = location.x;
    position.y = location.y;
    
    interaction = kInteraction_Drop;
    
    //NSLog(@"Molecule %d has been DROPPED (%d) ...", ID, interaction);
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(interaction == kInteraction_Drag) {
        interaction = kInteraction_Drop;
        state = kEntity_Alive;
    }
    
    //NSLog(@"Molecule %d has been CANCELLED (%d) ...", ID, interaction);
}

@end
