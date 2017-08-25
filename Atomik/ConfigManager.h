//
//  ConfigManager.h
//  Atomik
//
//  Created by James on 11/21/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "UIFadeButton.h"
#import "UISliderControl.h"
#import "UITextLabel.h"
#import "AudioConfig.h"
#import "GameConfig.h"
#import "MenuConfig.h"
#import "StageConfig.h"
#import "DailyConfig.h"
#import "CreditsConfig.h"
#import "ScoreConfig.h"
#import "PurchaseConfig.h"

@interface ConfigManager : NSObject {
    AudioConfig *audioConfig;
    GameConfig *gameConfig;
    MenuConfig *menuConfig;
    StageConfig *stageConfig;
    DailyConfig *dailyConfig;
    ScoreConfig *scoreConfig;
    CreditsConfig *creditsConfig;
    PurchaseConfig *purchaseConfig;
}

+ (id)sharedConfigManager;

- (void)loadAudioConfigWithWidth:(int)width andHeight:(int)height;
- (void)loadGameConfigWithWidth:(int)width andHeight:(int)height;
- (void)loadMenuConfigWithWidth:(int)width andHeight:(int)height;
- (void)loadStageConfigWithWidth:(int)width andHeight:(int)height;
- (void)loadDailyConfigWithWidth:(int)width andHeight:(int)height;
- (void)loadScoreConfigWithWidth:(int)width andHeight:(int)height;
- (void)loadCreditsConfigWithWidth:(int)width andHeight:(int)height;
- (void)loadPurchaseConfigWithWidth:(int)width andHeight:(int)height;

- (AudioConfig*)getAudioConfig;
- (GameConfig*)getGameConfig;
- (MenuConfig*)getMenuConfig;
- (StageConfig*)getStageConfig;
- (DailyConfig*)getDailyConfig;
- (ScoreConfig*)getScoreConfig;
- (CreditsConfig*)getCreditsConfig;
- (PurchaseConfig*)getPurchaseConfig;

@end
