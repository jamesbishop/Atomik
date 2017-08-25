//
//  CreditsScene.h
//  Atomik
//
//  Created by James on 11/11/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "AbstractScene.h"

@interface CreditsScene : AbstractScene {
    CreditsConfig *config;

	Image *background;
    Image *sceneTitle;
    Image *scenePanel;
    Image *sceneTouch;
    
    float upperPanelHeight;
    float lowerPanelHeight;
    float upperPanelDelta;
    float lowerPanelDelta;
    
    float musicVolume;
    float effectsVolume;
    
    BOOL doorsOpen;
    
    Emitter *emitter;
}

@end
