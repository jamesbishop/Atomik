//
//  ChallengeConfig.h
//  Atomik
//
//  Created by James on 6/9/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyConfig : NSObject {
    NSString *sceneTitle;
    NSString *sceneImage;
    NSString *sceneMusic;
    CGPoint titlePosition;
    NSMutableArray *details;
    NSMutableArray *buttons;
}

@property (nonatomic, retain) NSString *sceneTitle;
@property (nonatomic, retain) NSString *sceneImage;
@property (nonatomic, retain) NSString *sceneMusic;
@property (nonatomic, assign) CGPoint titlePosition;
@property (nonatomic, retain) NSMutableArray *details;
@property (nonatomic, retain) NSMutableArray *buttons;

@end
