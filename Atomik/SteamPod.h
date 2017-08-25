//
//  SteamPod.h
//
//  Created by James Bishop on 7/15/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "AbstractSpawnpod.h"
#import "GameManager.h"

@interface SteamPod : AbstractSpawnpod {
    Image *idleImage;
    Image *activeImage;
    Emitter *emitter;
    Animation *animation;
    
    float angle;
    float rotation;
    float xDelta;
    float xVariance;
    float yDelta;
    float yVariance;
    
    float timer;
}

@property (nonatomic, retain) Image *idleImage;
@property (nonatomic, retain) Image *activeImage;
@property (nonatomic, retain) Animation *animation;

- (id)initAtPoint:(CGPoint)point;

- (void)fire;
- (BOOL)isReady;

@end
