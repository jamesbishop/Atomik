//
//  Vector.h
//
//  Created by James Bishop on 21/09/2013.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import <Foundation/NSObject.h>

#import <stdio.h>
#import <math.h>

@interface Vector: NSObject {
@public
    float x;
    float y;
    float z;
}

- (Vector*)initWithX:(float)newX andY:(float)newY andZ:(float)newZ;

- (float)length;
- (void)negate;
- (void)normalize;
- (void)scale:(float)value;
- (float)angle:(Vector*)v;

- (float)distance:(Vector*)v;
+ (float)distance:(Vector*)v1 from:(Vector*)v2;

- (float)dot:(Vector*)v;
+ (float)dot:(Vector*)v1 with:(Vector*)v2;

- (Vector*)cross:(Vector*)v;
+ (Vector*)cross:(Vector*)v1 with:(Vector*)v2;

- (void)add:(Vector*)v;
- (void)sub:(Vector*)v;
- (void)mul:(Vector*)v;
- (void)div:(Vector*)v;

- (void)rotate:(float)rotx andY:(float)roty andZ:(float)rotz;

- (void)print;

@end

