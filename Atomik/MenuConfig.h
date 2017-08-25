//
//  MenuConfig.h
//  Atomik
//
//  Created by James on 1/18/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MenuConfig : NSObject {
    NSString *sceneTitle;
    NSString *sceneImage;
    NSString *sceneMusic;
    int menuTitleX;
    int menuTitleY;
    int iconTitleY;
    NSMutableArray *buttons;
}

@property (nonatomic, retain) NSString *sceneTitle;
@property (nonatomic, retain) NSString *sceneImage;
@property (nonatomic, retain) NSString *sceneMusic;
@property (nonatomic, assign) int menuTitleX;
@property (nonatomic, assign) int menuTitleY;
@property (nonatomic, assign) int iconTitleY;
@property (nonatomic, retain) NSMutableArray *buttons;

@end
