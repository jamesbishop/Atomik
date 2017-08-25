//
//  Trajectory.h
//
//  Created by James Bishop on 21/09/2013.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import <Foundation/NSObject.h>
#import <Foundation/Foundation.h>
#import <math.h>
#import <stdio.h>

#import "Vector.h"

#define GRAVITY				9.8
#define METRES_PER_FOOT		3.2808399
#define FEET_PER_METRE		0.3048

// 100mph = 44.2m/s (approx)

@interface Trajectory: NSObject {
   
}

- (float)toFeet:(float)metres;
- (float)toMetres:(float)feet;
- (float)toRadians:(float)angle;
- (float)toDegrees:(float)radians;

- (float)requiredLaunchIncline:(float)range height:(float)height;
- (float)launchVelocityByIncline:(float)range incline:(float)incline;
- (float)launchVelocityByHeight:(float)range height:(float)height;
- (float)horizontalRange:(float)velocity incline:(float)incline;
- (float)totalFlightTime:(float)velocity incline:(float)incline;
- (float)peakHeight:(float)velocity incline:(float)incline;

- (Vector*)project:(float)velocity incline:(float)incline time:(float)time;

- (void)print;

@end


