//
//  Vector.m
//
//  Created by James Bishop on 21/09/2013.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import "Vector.h"

@implementation Vector

- (Vector*)initWithX:(float)newX andY:(float)newY andZ:(float)newZ {
    self = [super init];
    if(self) {
    	x = newX; 
    	y = newY; 
    	z = newZ;
    }
    return self;
}

- (float)length {
    return sqrt(x * x + y * y + z * z);
}

- (void)negate {
    x = -x;
    y = -y;
    z = -z;
}

- (void)normalize {
    float normal = 1.0 / [self length];
    x *= normal;
    y *= normal;
    z *= normal;
}

- (void)scale:(float)value {
    x *= value;
    y *= value;
    z *= value;
}

- (float)angle:(Vector*)v {
    float dot = [self dot:v] / ([self length] * [v length] );
    
    if(dot < -1.0) dot = -1.0;
    if(dot >  1.0) dot =  1.0;
    
    // In radians
    return (float) acos(dot);
}

- (float)distance:(Vector*)v {
    float dx = x - v->x;
    float dy = y - v->y;
    float dz = z - v->z;
    
    return sqrt(dx * dx + dy * dy + dz * dz);
}

+ (float)distance:(Vector*)v1 from:(Vector*)v2 {
    float dx = v1->x - v2->x;
    float dy = v1->y - v2->y;
    float dz = v1->z - v2->z;
    
    return sqrt(dx * dx + dy * dy + dz * dz);
}

- (float)dot:(Vector*)v {
    return (x * v->x) + (y * v->y) + (z * v->z); 
}

+ (float)dot:(Vector*)v1 with:(Vector*)v2 {
    return (v1->x * v2->x) + (v1->y * v2->y) + (v1->z * v2-> z);
}

- (Vector*)cross:(Vector*)v {
    float cx = y * v->z - v->y * z;
    float cy = z * v->x - v->z * x;
    float cz = x * v->y - v->x * y;
    x = cx;
    y = cy;
    z = cz;
    
    return self;
}

+ (Vector*)cross:(Vector*)v1 with:(Vector*)v2 {
    float cx = (v1->y * v2->z) - (v2->y * v1->z);
    float cy = (v1->z * v2->x) - (v2->z * v1->x);
    float cz = (v1->x * v2->y) - (v2->x * v1->y);
	
    Vector *v = [[Vector alloc] init];
    v->x = cx;
    v->y = cy;
    v->z = cz;
    
    return v;
}

- (void)add:(Vector*)v {
    x += v->x;
    y += v->y;
    z += v->z;
}

- (void)sub:(Vector*)v {
    x -= v->x;
    y -= v->y;
    z -= v->z;
}

- (void)mul:(Vector*)v {
    x *= v->x;
    y *= v->y;
    z *= v->z;
}

- (void)div:(Vector*)v {
    x /= v->x;
    y /= v->y;
    z /= v->z;
}

- (void)rotate:(float)rotx andY:(float)roty andZ:(float)rotz {
    float temp_x = 0, temp_y = 0, temp_z = 0;
    	
    // ** X axis rotation **
    temp_y = (y * cos(rotx)) - (z * sin(rotx));
    temp_z = (z * cos(rotx)) + (y * sin(rotx));

    //(Copy NewY and NewZ into OldY and OldZ)
    y = temp_y;
    z = temp_z;

    // ** Y axis rotation **
    temp_z = (z * cos(roty)) - (x * sin(roty));
    temp_x = (x * cos(roty)) + (z * sin(roty));

    //(Copy NewZ and NewX into OldZ and OldX)
    z = temp_z;
    x = temp_x;

    // ** Z axis rotation **
    temp_x = (x * cos(rotz)) - (y * sin(rotz));
    temp_y = (y * cos(rotz)) + (x * sin(rotz));
    	
    x = temp_x;
    y = temp_y;
}

-(void)print {
	printf("Vector: (X=%f, Y=%f, Z=%f)", x, y, z);
}

-(void) dealloc {
    [super dealloc];
}

@end
