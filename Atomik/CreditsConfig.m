//
//  CreditsConfig.m
//  Atomik
//
//  Created by James on 6/21/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "CreditsConfig.h"

@implementation CreditsConfig

@synthesize sceneTitle;
@synthesize sceneImage;
@synthesize sceneMusic;
@synthesize titlePosition;
@synthesize panelPosition;
@synthesize touchPosition;

- (void)dealloc {
    [super dealloc];
    [sceneTitle release];
    [sceneImage release];
    [sceneMusic release];
}

- (id)init {
    if (self = [super init]) {
        // Nothing to do at this point.
    }
    return self;
}

@end
