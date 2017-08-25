//
//  ServerScore.h
//  Atomik
//
//  Created by James on 10/19/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerHeader.h"

@interface PlayerScore : NSObject {
    ServerHeader *header;
    int width;
    int height;
    BOOL retina;
    BOOL lite;
    int stage;
    int level;
    int molecules;
    int success;
    int failure;
    int missed;
    int collisions;
    float duration;
    int score;
    float target;
    float percentage;
    int livesAllowed;
    int livesRemaining;
    int progress;
}

@property (nonatomic, retain) ServerHeader *header;
@property (nonatomic, assign) int width;
@property (nonatomic, assign) int height;
@property (nonatomic, assign) BOOL retina;
@property (nonatomic, assign) BOOL lite;
@property (nonatomic, assign) int stage;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int molecules;
@property (nonatomic, assign) int success;
@property (nonatomic, assign) int failure;
@property (nonatomic, assign) int missed;
@property (nonatomic, assign) int collisions;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) int score;
@property (nonatomic, assign) float target;
@property (nonatomic, assign) float percentage;
@property (nonatomic, assign) int livesAllowed;
@property (nonatomic, assign) int livesRemaining;
@property (nonatomic, assign) int progress;


@end
