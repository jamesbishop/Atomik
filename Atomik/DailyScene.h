//
//  DailyScene.h
//  Atomik
//
//  Created by James on 6/9/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "DailyControl.h"
#import "DailyChallenge.h"
#import "UIHelper.h"
#import "UITextLabel.h"

@interface DailyScene : AbstractScene {
    DailyConfig *config;
    DailyControl *control;
    
	Image *background;
    Image *sceneTitle;
    
    Font *font;
   
    NSMutableArray *details;
    NSMutableArray *buttons;

    float upperPanelHeight;
    float lowerPanelHeight;
    float upperPanelDelta;
    float lowerPanelDelta;
    
    float musicVolume;
    float effectsVolume;
    
    float _displayMusicVolume;
    float _displayEffectsVolume;
    
    BOOL doorsOpen;
    BOOL levelLoaded;
    
    Emitter *emitter;
}

@end
