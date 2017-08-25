//
//  ScoreScene.h
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "NetworkManager.h"
#import "UIHelper.h"
#import "ScoreConfig.h"

@interface ScoreScene : AbstractScene {
    ScoreConfig *config;
    
	Image *background;
    Image *sceneTitle;
    Image *touchScreen;
    Font *font;

    NSMutableArray *levels;
    NSMutableArray *results;
    
    float upperPanelHeight;
    float lowerPanelHeight;
    float upperPanelDelta;
    float lowerPanelDelta;
    
    float musicVolume;
    float effectsVolume;
    
    BOOL doorsOpen;
}

@end
