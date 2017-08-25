//
//  Level.h
//  Atomik
//
//  Created by James on 9/15/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Level : NSObject {
    NSString *title;
    NSString *background;
    NSString *pipeline;
    NSString *scoreboard;
    NSString *music;
    float duration;
    int lives;
    float target;
    NSMutableArray *sinkholes;
    NSMutableArray *spawnpods;
}

@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *background;
@property (nonatomic, retain) NSString *pipeline;
@property (nonatomic, retain) NSString *scoreboard;
@property (nonatomic, retain) NSString *music;
@property (nonatomic, assign) float duration;
@property (nonatomic, assign) int lives;
@property (nonatomic, assign) float target;
@property (nonatomic, retain) NSMutableArray *sinkholes;
@property (nonatomic, retain) NSMutableArray *spawnpods;

@end
