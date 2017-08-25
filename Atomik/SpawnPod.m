//
//  SpawnPod.m
//
//  Created by James Bishop on 5/12/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "SpawnPod.h"

@implementation SpawnPod

- (id)initAtPoint:(CGPoint)point {
	self = [super init];
	if (self != nil) {
        Image *image = [[[ImageManager sharedImageManager] getImageWithName:@"SpawnPod"] retain];
        
        [self setGraphic:image];
		[self setState:kEntity_Idle];
        [self setDirection:kDirection_None];
        [self setVisibility:kVisibility_Show];
        [self setInteraction:kInteraction_None];
        [self setDelay:RANDOM_0_TO_1() * DEFAULT_SPAWNPOD_DELAY];
        [self setSpeed:DEFAULT_SPAWNPOD_SPEED];
        [self setPosition:point];
        [self setType:SPAWNPOD_MOLECULE];
        
        [super setDepth:1];
        [super updateBounds];
        
        [image release];
	}
	return self;
}

- (void)open {
    state = kEntity_Idle;
}

- (void)fire {
    // We have initiated a call to the spawn pod fire routine, so
    // we need to create a new entity and add it to the game
    // pipeline, so that it gets launched into the game system.
    state = kEntity_Alive;
    
    // We have initiated a call to the spawn pod fire routine, so
    // we need to create a new entity and add it to the game
    // pipeline, so that it gets launched into the game system.
    /*
    NSString *spawnSound = [NSString stringWithFormat:@"SpawnPod_%d", (int)speed];
    [[SoundManager sharedSoundManager] playSoundWithKey:spawnSound];
    */
    [[SoundManager sharedSoundManager] playSoundWithKey:@"SpawnPod"];
    
    timer = 0.0f;
    next = delay + (RANDOM_0_TO_1() * delay);
}

- (BOOL)isReady {
    //NSLog(@"  - SPAWN: Timer=%.3f, Next=%.3f, State=%d", timer, next, state);
    if((timer > next) && (state == kEntity_Idle)) {
        return YES;
    }
    return NO;
}

- (void)update:(float)delta {

    // Keep a track of how long this cycle has been running.
    timer += delta;

	// Spawn pods do not actually move, but rather they hide the
    // creation of new molecules. We need to make sure the spawn
    // pods are rendered last, as they will always be on the top.
    if(state == kEntity_Alive) {

        // If the entity is not visible, we don't need to go to
        // all the additional animation checks and scenarios.
        if(visibility == kVisibility_Hide) {
            state = kEntity_Idle;
            return;
        }
        
        // Control the speed of the spawn pods movement.
        float movement = DEFAULT_SPAWNPOD_DELTA;
        
        // Entity is visible, so check which way it is pointing
        // so that we can update with the current sequences.
        if(direction == kDirection_Down) {  
            
            // Check if the lever needs to be pulled backwards??
            // The yDelta will range from (0 to 16)
            if(motion == 0) {
                if(yDelta < 16.0f) {
                    yDelta += (delta * (FRAME_RATE * movement));
                } else {
                    motion = 1;
                }
            }
            
            // Check if the lever needs to be pushed downwards??
            // The yDelta will range from (16 to -32)
            if(motion == 1) {
                if(yDelta > -32.0f) {
                    yDelta += (-delta * (FRAME_RATE * (movement * 2)));
                } else {
                    motion = 2;
                }
            }

            // Check if the lever needs to be pulled backwards??
            // The yDelta will range from (-32 to 0)
            if(motion == 2) {
                if(yDelta < 0.0f) {
                    yDelta += (delta * (FRAME_RATE * movement));
                } else {
                    motion = 0;
                    state = kEntity_Idle;
                }
            }
        }

        if(direction == kDirection_Up) {  
            
            // Check if the lever needs to be pulled backwards??
            // The yDelta will decrement from (0 to -16)
            if(motion == 0) {
                if(yDelta > -16.0f) {
                    yDelta += (-delta * (FRAME_RATE * movement));
                } else {
                    motion = 1;
                }
            }

            // Check if the lever needs to be pushed downwards??
            // The yDelta will increment from (-16 to 32)
            if(motion == 1) {
                if(yDelta < 32.0f) {
                    yDelta += (delta * (FRAME_RATE * (movement * 2)));
                } else {
                    motion = 2;
                }
            }

            // Check if the lever needs to be pulled backwards??
            // The yDelta will decrement from (32 to 0)
            if(motion == 2) {
                if(yDelta > 0.0f) {
                    yDelta += (-delta * (FRAME_RATE * movement));
                } else {
                    motion = 0;
                    state = kEntity_Idle;
                }
            }
        }

        if(direction == kDirection_Right) {  
            
            // Check if the lever needs to be pulled backwards??
            // The xDelta will decrement from (0 to -16)
            if(motion == 0) {
                if(xDelta > -16.0f) {
                    xDelta += (-delta * (FRAME_RATE * movement));
                } else {
                    motion = 1;
                }
            }
            
            // Check if the lever needs to be pushed downwards??
            // The xDelta will increment from (-16 to 32)
            if(motion == 1) {
                if(xDelta < 32.0f) {
                    xDelta += (delta * (FRAME_RATE * (movement * 2)));
                } else {
                    motion = 2;
                }
            }
            
            // Check if the lever needs to be pulled backwards??
            // The xDelta will decrement from (32 to 0)
            if(motion == 2) {
                if(xDelta > 0.0f) {
                    xDelta += (-delta * (FRAME_RATE * movement));
                } else {
                    motion = 0;
                    state = kEntity_Idle;
                }
            }
        }
        
        if(direction == kDirection_Left) {  
            
            // Check if the lever needs to be pulled backwards??
            // The xDelta will range from (0 to 16)
            if(motion == 0) {
                if(xDelta < 16.0f) {
                    xDelta += (delta * (FRAME_RATE * movement));
                } else {
                    motion = 1;
                }
            }
            
            // Check if the lever needs to be pushed downwards??
            // The xDelta will range from (16 to -32)
            if(motion == 1) {
                if(xDelta > -32.0f) {
                    xDelta += (-delta * (FRAME_RATE * (movement * 2)));
                } else {
                    motion = 2;
                }
            }
            
            // Check if the lever needs to be pulled backwards??
            // The xDelta will range from (-32 to 0)
            if(motion == 2) {
                if(xDelta < 0.0f) {
                    xDelta += (delta * (FRAME_RATE * movement));
                } else {
                    motion = 0;
                    state = kEntity_Idle;
                }
            }
        }
        
        [super updateBounds];
    }
}

- (void)render {
    // If the spawn pod has a state of "hide" then it means we
    // want it to act as normal, but not render an animation.
    if(visibility == kVisibility_Hide) {
        return;
    }
    
    // We need to point the pod in the right direction. We are
    // using a clockwise system, so adjust accordingly.
    float rotation = 0.0f;
    if(direction == kDirection_Down) {
        rotation = 90.0f;
    } else if(direction == kDirection_Left) {
        rotation = 180.0f;
    } else if(direction == kDirection_Up) {
        rotation = 270.0f;
    } else {
        // We are facing right, use default (0.0).
    }
    
    // Each spawn pod is facing in a different direction, so we
    // must cater for the fact that they fire different directions.
    CGPoint anchor = CGPointMake(position.x + xDelta, position.y + yDelta);

    [graphic setRotation:rotation];
    [graphic renderAtPoint:anchor centerOfImage:YES];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

@end
