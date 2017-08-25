//
//  SpawnPod.h
//
//  Created by James Bishop on 5/12/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "AbstractSpawnpod.h"
#import "GameManager.h"

@interface SpawnPod : AbstractSpawnpod {
    float xDelta;
    float yDelta;
    float timer;
    
    int motion;
}

- (id)initAtPoint:(CGPoint)point;

- (void)fire;
- (BOOL)isReady;

@end
