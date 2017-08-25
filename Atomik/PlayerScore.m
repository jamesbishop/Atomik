//
//  ServerScore.m
//  Atomik
//
//  Created by James on 10/19/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "PlayerScore.h"

@implementation PlayerScore {
    
}

@synthesize header;
@synthesize width;
@synthesize height;
@synthesize retina;
@synthesize lite;
@synthesize stage;
@synthesize level;
@synthesize molecules;
@synthesize success;
@synthesize failure;
@synthesize missed;
@synthesize collisions;
@synthesize duration;
@synthesize score;
@synthesize target;
@synthesize percentage;
@synthesize livesAllowed;
@synthesize livesRemaining;
@synthesize progress;

- (id) init {
    if (self = [super init]) {
        // Perform all the constructor tasks.
    }
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"width: %d, height: %d, retina: %d, lite: %d, stage: %d, level: %d, molecules: %d, success: %d, failure: %d, missed: %d, collisions: %d, duration: %.2f, score: %d, target: %.2f, percentage: %.2f, allowed: %d, remaining: %d, progress: %d", width, height, (retina ? 1 : 0), (lite ? 1 : 0), stage, level, molecules, success, failure, missed, collisions, duration, score, target, percentage, livesAllowed, livesRemaining, progress];
}
            
@end
