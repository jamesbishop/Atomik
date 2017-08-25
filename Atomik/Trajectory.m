//
//  Trajectory.m
//
//  Created by James Bishop on 21/09/2013.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import "Trajectory.h"

@interface Trajectory (Private)
- (float)vyt:(float)velocity incline:(float)incline time:(float)time;
- (float)fv013:(float)range incline:(float)incline;
- (float)a14:(float)range height:(float)height;
- (float)v14:(float)range height:(float)height;
@end

@implementation Trajectory

- (float)toFeet:(float)metres {
    return metres / FEET_PER_METRE;
}

- (float)toMetres:(float)feet {
    return feet * METRES_PER_FOOT;
}

- (float)toRadians:(float)angle {
    return angle * M_PI / 180;
}

- (float)toDegrees:(float)radians {
    return radians * 180 / M_PI;
}

- (float)vyt:(float)velocity incline:(float)incline time:(float)time {
    float radians = [self toRadians:incline];
    return velocity * sin(radians) - (GRAVITY * time);
}

- (float)fv013:(float)range incline:(float)incline {
	float radians = [self toRadians:incline];
    return sqrt(range * GRAVITY / sin(2.0f * radians));
}

- (float)a14:(float)range height:(float)height {
    return atan(4.0f * height / range);
}

- (float)v14:(float)range height:(float)height {
    return sqrt(range * GRAVITY / sin(2.0f * [self a14:range height:height]));
}

- (float)requiredLaunchIncline:(float)range height:(float)height {
    return [self a14:range height:height] * 180 / M_PI;
}

- (float)launchVelocityByIncline:(float)range incline:(float)incline {
    return [self fv013:range incline:incline];
}

- (float)launchVelocityByHeight:(float)range height:(float)height {
    return [self v14:range height:height];
}

- (float)horizontalRange:(float)velocity incline:(float)incline {
    float radians = [self toRadians:incline];
    return (velocity * velocity) * sin(2.0f * radians) / GRAVITY;
}

- (float)totalFlightTime:(float)velocity incline:(float)incline {
    return 2.0f * [self vyt:velocity incline:incline time:0.0f] / GRAVITY;
}

- (float)peakHeight:(float)velocity incline:(float)incline {
    float vyt = [self vyt:velocity incline:incline time:0.0f];
    return (vyt * vyt) / (2.0f * GRAVITY);
}

- (Vector*)project:(float)velocity incline:(float)incline time:(float)time {
    // Calculate individual points of the flights
    float angleInRadians = [self toRadians:incline];
	
    float cosineOfAngle = cos(angleInRadians);
    float sineOfAngle = sin(angleInRadians);
	
    float velocity_x = (velocity * cosineOfAngle);
    float velocity_y = (velocity * sineOfAngle);
	
	float x = (velocity_x * time);
	float y = (velocity_y * time) - (0.5 * GRAVITY * time * time);
	
	return [[Vector alloc] initWithX:x andY:y andZ:0.0f];
}

- (void)print {
    printf("Trajectory -> Nothing to print!");
}

-(void) dealloc {
    [super dealloc];
}

@end
