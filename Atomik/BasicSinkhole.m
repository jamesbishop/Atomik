//
//  BasicSinkhole.m
//
//  Created by James Bishop on 6/24/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "BasicSinkhole.h"

@implementation BasicSinkhole

- (id)initWithImage:(Image*)image atPoint:(CGPoint)point {
	self = [super init];
	if (self != nil) {
        [self setGraphic:image];
		[self setState:kEntity_Idle];
        [self setDirection:kDirection_None];
        [self setVisibility:kVisibility_Show];
        [self setInteraction:kInteraction_None];
        [self setSpeed:0.0f];
        [self setPosition:point];
        [self setSensitivity:0.0f];
        
        angle = 0.0f;

        startColour     = Color4fMake(1.0f, 1.0f, 1.0f, 1.0f);
        startVariance   = Color4fMake(0.5f, 0.5f, 0.5f, 1.0f);
        finishColour    = Color4fMake(0.0f, 0.0f, 0.0f, 0.0f);
        finishVariance  = Color4fMake(0.0f, 0.0f, 0.0f, 0.0f);

        // Angles: 0=Right, 90=Down, 180=Left, 270=Up
        /*
        emitter = [[Emitter alloc] initParticleEmitterWithImageNamed:@"particle"
                                                            position:Vector2fMake(point.x, point.y)
                                              sourcePositionVariance:Vector2fMake(0, 0)
                                                               speed:5.0f
                                                       speedVariance:5.0f
                                                    particleLifeSpan:1.0f	
                                            particleLifespanVariance:1.0f
                                                               angle:angle     
                                                       angleVariance:10.0f
                                                             gravity:Vector2fMake(0.0f, -0.0f)
                                                          startColor:Color4fMake(0.76f, 0.12f, 0.3f, 1.0f)
                                                  startColorVariance:Color4fMake(1.0f, 0.0f, 0.0f, 1.0f)
                                                         finishColor:Color4fMake(0.0f, 0.4f, 1.0f, 0.0f)    
                                                 finishColorVariance:Color4fMake(0.0f, 0.0f, 0.0f, 0.0f)
                                                        maxParticles:1000
                                                        particleSize:10
                                                particleSizeVariance:10
                                                            duration:1.0f
                                                       blendAdditive:YES];
        
        [emitter setActive:NO];
         */
        
        emitter = [[Emitter alloc] initParticleEmitterWithImageNamed:PARTICLE_EMITTER_ROUND
                                                            position:Vector2fMake(point.x, point.y)
                                              sourcePositionVariance:Vector2fMake(10, 10)
                                                               speed:0.5f
                                                       speedVariance:0.5f
                                                    particleLifeSpan:0.5f	
                                            particleLifespanVariance:0.5f
                                                               angle:angle    
                                                       angleVariance:360.0f
                                                             gravity:Vector2fMake(0.0f, 0.0f)
                                                          startColor:startColour
                                                  startColorVariance:startVariance
                                                         finishColor:finishColour    
                                                 finishColorVariance:finishVariance
                                                        maxParticles:250
                                                        particleSize:5
                                                particleSizeVariance:5
                                                            duration:-1.0f
                                                       blendAdditive:YES];
           
        [emitter setActive:YES];

        [super updateBounds];
	}
	return self;
}

- (void)update:(float)delta {
    
    if([super ID] == 1) {
        startColour    = Color4fMake(0.30f, 0.50f, 1.00f, 1.0f);
        startVariance  = Color4fMake(0.00f, 0.00f, 0.00f, 1.0f);
        finishColour   = Color4fMake(0.00f, 0.00f, 0.20f, 0.0f);
        finishVariance = Color4fMake(0.00f, 0.00f, 0.20f, 0.0f);
        
    } else if([super ID] == 2) {
        startColour    = Color4fMake(0.50f, 1.00f, 0.30f, 1.0f);
        startVariance  = Color4fMake(0.00f, 0.00f, 0.00f, 1.0f);
        finishColour   = Color4fMake(0.00f, 0.20f, 0.00f, 0.0f);
        finishVariance = Color4fMake(0.00f, 0.20f, 0.00f, 0.0f); 
        
    } else if([super ID] == 3) {
        startColour    = Color4fMake(0.98f, 0.04f, 0.92f, 1.0f);
        startVariance  = Color4fMake(0.20f, 0.00f, 0.20f, 1.0f);
        finishColour   = Color4fMake(0.90f, 0.10f, 0.85f, 0.0f);
        finishVariance = Color4fMake(0.20f, 0.00f, 0.15f, 0.0f); 
        
    } else if([super ID] == 4) {
        startColour    = Color4fMake(1.00f, 0.50f, 0.00f, 1.0f);
        startVariance  = Color4fMake(0.00f, 0.00f, 0.00f, 1.0f);
        finishColour   = Color4fMake(0.20f, 0.00f, 0.00f, 0.0f);
        finishVariance = Color4fMake(0.20f, 0.00f, 0.00f, 0.0f); 
        
    } else {
        startColour    = Color4fMake(1.00f, 0.25f, 0.25f, 1.0f);
        startVariance  = Color4fMake(0.00f, 0.00f, 0.00f, 1.0f);
        finishColour   = Color4fMake(0.20f, 0.10f, 0.10f, 0.0f);
        finishVariance = Color4fMake(0.20f, 0.10f, 0.10f, 0.0f); 
        
    }
    
    [emitter setStartColor:startColour];
    [emitter setStartColorVariance:startVariance];
    [emitter setFinishColor:finishColour];
    [emitter setFinishColorVariance:finishVariance];
     
    [emitter update:delta];
    
    if([self state] == kEntity_Alive) {
        angle += (delta*FRAME_RATE) * 15.0f;
        if(angle >= 360.0f) {
            angle = 0.0f;
        }
    } else {
        angle = 0.0f;
    }

    [emitter setAngle:angle];
    
    [super updateBounds];
}

- (void)render {
    [graphic renderAtPoint:position centerOfImage:YES];
    [emitter renderParticles];
}

@end
