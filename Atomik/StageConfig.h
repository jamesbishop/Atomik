//
//  StageMenuConfig.h
//  Atomik
//
//  Created by James on 11/21/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StageConfig : NSObject {
    NSString *sceneTitle;
    NSString *sceneImage;
    NSString *sceneMusic;
    CGPoint titlePosition;
    int iconFontY;
    NSMutableArray *icons;
    NSMutableArray *buttons;
}

@property (nonatomic, retain) NSString *sceneTitle;
@property (nonatomic, retain) NSString *sceneImage;
@property (nonatomic, retain) NSString *sceneMusic;
@property (nonatomic, assign) CGPoint titlePosition;
@property (nonatomic, assign) int iconFontY;
@property (nonatomic, retain) NSMutableArray *icons;
@property (nonatomic, retain) NSMutableArray *buttons;

@end
