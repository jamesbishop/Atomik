//
//  PurchaseConfig.m
//  Atomik
//
//  Created by James on 2/9/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "PurchaseConfig.h"

@implementation PurchaseConfig

@synthesize sceneTitle;
@synthesize sceneImage;
@synthesize sceneMusic;
@synthesize titlePosition;
@synthesize buttons;

- (void)dealloc {
    [super dealloc];
    [buttons dealloc];
}

- (id)init {
    if (self = [super init]) {
        // Nothing to do at this point.
        buttons = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
