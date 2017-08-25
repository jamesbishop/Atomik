//
//  ProgressManager.h
//  Atomik
//
//  Created by James on 2/1/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Constants.h"
#import "UIHelper.h"
#import "Device.h"
#import "DeviceManager.h"
#import "ProgressData.h"

#define REGISTRATION_FILE       @"Atomik_Settings.json"

#define CLEAR_REGISTRATION      NO
#define OPEN_ALL_CONTENT        NO

#define STAGE_FILENAME          @"Atomik_S%d.unlock"
#define LEVEL_FILENAME          @"Atomik_S%d_L%d_(%d).unlock"

@interface ProgressManager : NSObject {
    DeviceManager *_deviceManager;
    ProgressData *progressData;
}

+ (id)sharedProgressManager;

- (void)checkGameRegistration;

- (ProgressData*)getProgressData;
- (ProgressData*)loadProgressData;
- (void)saveProgressData:(ProgressData*)data;

- (BOOL)isStageUnlocked:(int)stage;
- (BOOL)isStageUnlocked:(int)stage withLevel:(int)level;

- (int)getStateForStage:(int)stage withLevel:(int)level;
- (BOOL)setState:(int)state withStage:(int)stage andLevel:(int)level;

- (BOOL)unlockStage:(int)stage;
- (BOOL)unlockStage:(int)stage withLevel:(int)level;

- (void)updateStage:(int)stage withLevel:(int)level andState:(int)state;

@end
