//
//  Level.m
//  Atomik
//
//  Created by James on 9/15/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "Level.h"

@implementation Level

@synthesize title;
@synthesize background;
@synthesize pipeline;
@synthesize scoreboard;
@synthesize music;
@synthesize duration;
@synthesize lives;
@synthesize target;
@synthesize sinkholes;
@synthesize spawnpods;

- (id)init {
    sinkholes = [[NSMutableArray alloc] init];
    spawnpods = [[NSMutableArray alloc] init];
	return self;
}

- (void) dealloc {
    [super dealloc];
    [sinkholes release];
    [spawnpods release];
}

@end
