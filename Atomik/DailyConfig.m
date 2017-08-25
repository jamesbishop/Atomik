//
//  ChallengeConfig.m
//  Atomik
//
//  Created by James on 6/9/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "DailyConfig.h"

@implementation DailyConfig

@synthesize sceneTitle;
@synthesize sceneImage;
@synthesize sceneMusic;
@synthesize titlePosition;
@synthesize details;
@synthesize buttons;

- (void)dealloc {
    [super dealloc];
    [details dealloc];
    [buttons dealloc];
}

- (id)init {
    if (self = [super init]) {
        // Nothing to do at this point.
        details = [[NSMutableArray alloc] init];
        buttons = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
