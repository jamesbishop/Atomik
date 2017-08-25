//
//  AbstractSpawnpod.h
//
//  Created by James Bishop on 7/15/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "AbstractEntity.h"

#define SPAWNPOD_MOLECULE   1
#define STEAMPOD_MOLECULE   2

@interface AbstractSpawnpod : AbstractEntity {
    int podID;
    int depth;
    int type;
    
    float next;
}

@property (nonatomic, assign) int podID;
@property (nonatomic, assign) int depth;
@property (nonatomic, assign) int type;

- (id)initAtPoint:(CGPoint)point;

- (void)open;
- (void)fire;
- (BOOL)isReady;

@end
