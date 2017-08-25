//
//  StageScene.h
//  Atomik
//
//  Created by James on 11/9/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "StageControl.h"

@interface StageScene : AbstractScene {    
    StageConfig *config;
    StageControl *control;
    
    Font *font;
	Image *background;
    Image *sceneTitle;
    NSMutableArray *icons;
    NSMutableArray *buttons;
    
    float upperPanelHeight;
    float lowerPanelHeight;
    float upperPanelDelta;
    float lowerPanelDelta;
    
    float musicVolume;
    float effectsVolume;
    
    BOOL doorsOpen;
    BOOL menuActive;
    int activeMenuOption;
    
    int currentStage;
    int currentLevel;
    int displayStage;
    
    Emitter *emitter;
}

@end
