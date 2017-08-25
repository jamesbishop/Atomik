//
//  StageMenuConfig.m
//  Atomik
//
//  Created by James on 11/21/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "StageConfig.h"

@implementation StageConfig

@synthesize sceneTitle;
@synthesize sceneImage;
@synthesize sceneMusic;
@synthesize titlePosition;
@synthesize iconFontY;
@synthesize icons;
@synthesize buttons;
    
- (void)dealloc {
    [super dealloc];
    [icons release];
    [buttons release];
}

- (id)init {
    if (self = [super init]) {
        // Nothing to do at this point.
        icons = [[NSMutableArray alloc] init];
        buttons = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
