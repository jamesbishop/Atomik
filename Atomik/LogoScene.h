//
//  LogoScene.h
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"

#define SCENE_DURATION      5.0f

@interface LogoScene : AbstractScene {
	Image *background;
    float duration;
    
    float upperPanelHeight;
    float lowerPanelHeight;
    float upperPanelDelta;
    float lowerPanelDelta;
    
    float musicVolume;
    float effectsVolume;
    
    BOOL doorsOpen;
    BOOL sceneReady;
}

@end
