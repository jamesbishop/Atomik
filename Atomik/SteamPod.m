//
//  SteamPod.m
//
//  Created by James Bishop on 5/12/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "SteamPod.h"

@interface SteamPod (Private)
- (void)rotate;
@end

@implementation SteamPod

@synthesize idleImage;
@synthesize activeImage;
@synthesize animation;

- (id)initAtPoint:(CGPoint)point {
	self = [super init];
	if (self != nil) {
        
        [self setGraphic:nil];
        [self setAnimation:nil];
		[self setState:kEntity_Idle];
        [self setDirection:kDirection_None];
        [self setVisibility:kVisibility_Show];
        [self setInteraction:kInteraction_None];
        [self setDelay:RANDOM_0_TO_1() * DEFAULT_STEAMPOD_DELAY];
        [self setSpeed:DEFAULT_STEAMPOD_SPEED];
        [self setPosition:point];
        
        [self setType:STEAMPOD_MOLECULE];
        
        [super setDepth:2];
        [super updateBounds];
                
        rotation = 0.0f;
        angle = 0.0f;
        xDelta = 0.0f;
        yDelta = 0.0f;
        xVariance = 0.0f;
        yVariance = 0.0f;

        /*
        emitter = [[Emitter alloc] initParticleEmitterWithImageNamed:PARTICLE_EMITTER_TYPE
                                                            position:Vector2fMake(point.x, point.y)
                                              sourcePositionVariance:Vector2fMake(5, 5)
                                                               speed:1.0f
                                                       speedVariance:1.0f
                                                    particleLifeSpan:0.75f	
                                            particleLifespanVariance:1.0f
                                                               angle:angle     
                                                       angleVariance:25.0f
                                                             gravity:Vector2fMake(0.0f, -0.0f)
                                                          startColor:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                  startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
                                                         finishColor:Color4fMake(1.0f, 1.0f, 1.0f, 0.5f)    
                                                 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.5f)
                                                        maxParticles:250
                                                        particleSize:7.5f
                                                particleSizeVariance:5
                                                            duration:-1.0f
                                                       blendAdditive:YES];
        */
        /*
        emitter = [[Emitter alloc] initParticleEmitterWithImageNamed:PARTICLE_EMITTER_TYPE
                                                            position:Vector2fMake(point.x, point.y)
                                              sourcePositionVariance:Vector2fMake(5, 5)
                                                               speed:1.0f
                                                       speedVariance:1.0f
                                                    particleLifeSpan:1.0f	
                                            particleLifespanVariance:1.0f
                                                               angle:angle     
                                                       angleVariance:25.0f
                                                             gravity:Vector2fMake(0.0f, -0.0f)
                                                          startColor:Color4fMake(0.5f, 0.5f, 0.5f, 1.0f)
                                                  startColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 1.0f)
                                                         finishColor:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)    
                                                 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
                                                        maxParticles:500
                                                        particleSize:7.5f
                                                particleSizeVariance:5
                                                            duration:-1.0f
                                                       blendAdditive:NO];
        */
        emitter = [[Emitter alloc] initParticleEmitterWithImageNamed:PARTICLE_EMITTER_SPOTLITE
                                                            position:Vector2fMake(point.x, point.y)
                                              sourcePositionVariance:Vector2fMake(5, 5)
                                                               speed:1.0f
                                                       speedVariance:1.0f
                                                    particleLifeSpan:1.0f
                                            particleLifespanVariance:1.0f
                                                               angle:angle
                                                       angleVariance:25.0f
                                                             gravity:Vector2fMake(0.0f, -0.0f)
                                                          startColor:Color4fMake(0.5f, 0.5f, 0.5f, 0.5f)
                                                  startColorVariance:Color4fMake(0.5f, 0.5f, 0.5f, 0.5f)
                                                         finishColor:Color4fMake(0.5f, 0.5f, 0.5f, 0.2f)
                                                 finishColorVariance:Color4fMake(0.5f, 0.5f, 0.5f, 0.2f)
                                                        maxParticles:500
                                                        particleSize:7.5f
                                                particleSizeVariance:5
                                                            duration:-1.0f
                                                       blendAdditive:YES];
        [emitter setActive:NO];
	}
	return self;
}

- (void)open {
    // We have initiated a call to the spawn pod open routine, so
    // we need to create a new entity and add it to the game
    // pipeline, so that it gets launched into the game system.
    state = kEntity_Alive;
    
    // We need to start the animation sequence to start running.
    [animation setRunning:YES];
    [animation setRepeat:NO];
}

- (void)fire {
    // If the entity is not visible, we don't need to go to
    // all the additional animation checks and scenarios.
    [[SoundManager sharedSoundManager] playSoundWithKey:@"SteamPod"];
    
    timer = 0.0f;
    next = delay + (RANDOM_0_TO_1() * delay);
}

- (BOOL)isReady {
    if((timer > next) && (state == kEntity_Alive)) {
        return YES;
    }
    return NO;
}

- (void)rotate {
    // We need to point the pod in the right direction. We are
    // using a clockwise system, so adjust accordingly.
    if(direction == kDirection_Down) {
        rotation = 90.0f;
        angle = 270.0f;
        xDelta = 0.0f;
        yDelta = -15.0f;
        xVariance = 5.0f;
        yVariance = 0.0f;
        
    } else if(direction == kDirection_Left) {
        rotation = 180.0f;
        angle = 180.0f;
        xDelta = -15.0f;
        yDelta = 0.0f;
        xVariance = 0.0f;
        yVariance = 5.0f;
        
    } else if(direction == kDirection_Up) {
        rotation = 270.0f;
        angle = 90.0f;
        xDelta = 0.0f;
        yDelta = 15.0f;
        xVariance = 5.0f;
        yVariance = 0.0f;
        
    } else {
        rotation = 0.0f;
        angle = 0.0f;
        xDelta = 15.0f;
        yDelta = 0.0f;
        xVariance = 0.0f;
        yVariance = 5.0f;
    }
}

- (void)update:(float)delta {
    
    // Keep a track of how long this cycle has been running.
    timer += delta;

    //NSLog(@"State: %d, Emitter: %@, Animation: %@ ", state, emitter.active ? @"Yes" : @"No", animation.running ? @"Yes" : @"No");
    

	// Spawn pods do not actually move, but rather they hide the
    // creation of new molecules. We need to make sure the spawn
    // pods are rendered last, as they will always be on the top.
    if(state == kEntity_Alive || state == kEntity_Idle) {
 
        // If the steam pod isn't active, just display the pipe crack.
        if(state == kEntity_Idle) {
            [self setGraphic:idleImage];
            
        } else {
            [self setGraphic:activeImage];
            
            // As a steam pod, we have the opening explosion to render if
            // the pod has just been broken open. Let's animate this first.
            if([animation running]) {
                [animation update:delta];
            } else {
                [emitter setActive:YES];
            }
        }

        
        [self rotate];

        [emitter setAngle:angle];
        [emitter setSourcePosition:Vector2fMake(position.x + xDelta, position.y + yDelta)];
        [emitter setSourcePositionVariance:Vector2fMake(5 + xVariance, 5 + yVariance)];
        [emitter update:delta];

        [super updateBounds];
    }
}

- (void)render {
    
    // Each spawn pod is facing in a different direction, so we
    // must cater for the fact that they fire different directions.
    if(state == kEntity_Idle || state == kEntity_Alive) {

        // If the spawn pod has a state of "hide" then it means we
        // want it to act as normal, but not render an animation.
        /*
        if(visibility == kVisibility_Hide) {
            return;
        }

        // Render the main representation of this entity pod.
        [graphic setRotation:rotation];
        [graphic renderAtPoint:CGPointMake(position.x, position.y) centerOfImage:YES];
        */

        // Render the main representation of this entity pod.
        if(visibility != kVisibility_Hide) {            
            [graphic setRotation:rotation];
            [graphic renderAtPoint:CGPointMake(position.x, position.y) centerOfImage:YES];
        }

        // If the particle emitter is active, render this first.
        if([emitter active]) {
            [emitter renderParticles];
        }
        
        // Run the animation sequence last, as it covers our entities.
        if([animation running]) {
            [animation renderAtPoint:position];
        }
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)dealloc {
    [super dealloc];
    [idleImage release];
    [activeImage release];
    [animation release];
}

@end
