//
//  UILocation.m
//  Atomik
//
//  Created by James on 3/22/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "UILocation.h"

@implementation UILocation

@synthesize location;
    
- (void)dealloc {
    [super dealloc];
}
    
- (id)initWithLocation:(CGPoint)newLocation {
    if(self = [super init]) {
        location = newLocation;
    }
    return self;
}
    
@end
