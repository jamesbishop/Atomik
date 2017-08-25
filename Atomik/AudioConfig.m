//
//  AudioConfig.m
//  Atomik
//
//  Created by James on 3/21/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "AudioConfig.h"

@implementation AudioConfig

@synthesize sceneTitle;
@synthesize sceneImage;
@synthesize sceneMusic;
@synthesize titlePosition;
@synthesize labels;
@synthesize sliders;
@synthesize buttons;
    
- (void)dealloc {
    [super dealloc];
    [labels dealloc];
    [sliders dealloc];
}
    
- (id)init {
    if (self = [super init]) {
        // Nothing to do at this point.
        labels = [[NSMutableArray alloc] init];
        sliders = [[NSMutableArray alloc] init];
        buttons = [[NSMutableArray alloc] init];
    }
    return self;
}
    
@end
