//
//  RegisterDevice.m
//  Atomik
//
//  Created by James on 4/16/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "RegisterDevice.h"

@implementation RegisterDevice {
    
}

- (id) init {
    if (self = [super init]) {
        // Perform all the constructor tasks.
    }
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"width: %d, height: %d, retina: %d, lite: %d", width, height, (retina ? 1 : 0), (lite ? 1 : 0)];
}

@end
