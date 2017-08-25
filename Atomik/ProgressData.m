//
//  ProgressData.m
//  Atomik
//
//  Created by James on 2/1/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "ProgressData.h"

@implementation ProgressData
    
@synthesize deviceID;
@synthesize platform;
@synthesize version;
@synthesize musicVolume;
@synthesize effectsVolume;

- (id)init {
    if (self = [super init]) {
        // Nothing to do at this point.
    }
    return self;
}

- (NSDictionary*)content {
    return [NSDictionary dictionaryWithObjectsAndKeys:
            deviceID, @"device-id",
            platform, @"platform",
            version, @"version",
            [NSNumber numberWithFloat:musicVolume], @"music-volume",
            [NSNumber numberWithFloat:effectsVolume], @"effects-volume",
            nil];
}

- (void)dealloc {
    [super dealloc];
}

@end
