//
//  CreditsConfig.h
//  Atomik
//
//  Created by James on 6/21/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditsConfig : NSObject {
    NSString *sceneTitle;
    NSString *sceneImage;
    NSString *sceneMusic;
    CGPoint titlePosition;
    CGPoint panelPosition;
    CGPoint touchPosition;
}

@property (nonatomic, retain) NSString *sceneTitle;
@property (nonatomic, retain) NSString *sceneImage;
@property (nonatomic, retain) NSString *sceneMusic;
@property (nonatomic, assign) CGPoint titlePosition;
@property (nonatomic, assign) CGPoint panelPosition;
@property (nonatomic, assign) CGPoint touchPosition;

@end
