//
//  LevelManager.h
//  Atomik
//
//  Created by James on 9/15/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Level.h"
#import "Image.h"
#import "BasicSinkhole.h"
#import "SpawnPod.h"
#import "SteamPod.h"
#import "ImageManager.h"
#import "SynthesizeSingleton.h"

@interface LevelManager : NSObject {
    ImageManager *_imageManager;
}

+ (LevelManager*)sharedLevelManager;

- (Level*)loadFromDeviceWithStage:(int)stage andLevel:(int)level andWidth:(int)width andHeight:(int)height;
- (Level*)loadFromServerWithStage:(int)stage andLevel:(int)level andWidth:(int)width andHeight:(int)height;

@end
