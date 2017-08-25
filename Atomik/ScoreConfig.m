//
//  ScoreConfig.m
//  Atomik
//
//  Created by James on 6/27/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "ScoreConfig.h"

@implementation ScoreConfig

@synthesize sceneTitle;
@synthesize sceneImage;
@synthesize sceneMusic;
@synthesize titlePosition;
@synthesize details;

- (void)dealloc {
    [super dealloc];
    [details dealloc];
}

- (id)init {
    if (self = [super init]) {
        // Nothing to do at this point.
        details = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
