//
//  AbstractSinkhole.m
//
//  Created by James Bishop on 4/28/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "AbstractSinkhole.h"

@implementation AbstractSinkhole

@synthesize ID;
@synthesize emitter;

- (void)boom {
    state = kEntity_Alive;
}

@end
