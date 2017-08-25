//
//  MenuConfig.m
//  Atomik
//
//  Created by James on 1/18/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "MenuConfig.h"

@implementation MenuConfig

@synthesize sceneTitle;
@synthesize sceneImage;
@synthesize sceneMusic;
@synthesize menuTitleX;
@synthesize menuTitleY;
@synthesize iconTitleY;
@synthesize buttons;

- (void)dealloc {
    [super dealloc];
    [buttons release];
}
    
- (id)init {
    if (self = [super init]) {
        // Nothing to do at this point.
        buttons = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
