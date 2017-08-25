//
//  AbstractMolecule.m
//
//  Created by James Bishop on 4/28/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "AbstractMolecule.h"

@implementation AbstractMolecule

@synthesize ID;
@synthesize unique;
@synthesize radius;
@synthesize scale;
@synthesize explosion;

- (void)explode {
    state = kEntity_Dying;
}

@end
