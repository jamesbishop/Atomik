//
//  AudioConfig.h
//  Atomik
//
//  Created by James on 3/21/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AudioConfig : NSObject {
    NSString *sceneTitle;
    NSString *sceneImage;
    NSString *sceneMusic;
    CGPoint titlePosition;
    NSMutableArray *labels;
    NSMutableArray *sliders;
    NSMutableArray *buttons;
}

@property (nonatomic, retain) NSString *sceneTitle;
@property (nonatomic, retain) NSString *sceneImage;
@property (nonatomic, retain) NSString *sceneMusic;
@property (nonatomic, assign) CGPoint titlePosition;
@property (nonatomic, retain) NSMutableArray *labels;
@property (nonatomic, retain) NSMutableArray *sliders;
@property (nonatomic, retain) NSMutableArray *buttons;

@end
