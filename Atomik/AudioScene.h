//
//  AudioScene.h
//  Atomik
//
//  Created by James on 2/2/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "AbstractScene.h"
#import "AudioConfig.h"
#import "AudioControl.h"
#import "UIHelper.h"
#import "UISliderControl.h"

@interface AudioScene : AbstractScene {
    AudioConfig *config;
    AudioControl *control;
    
	Image *background;
    Image *sceneTitle;
    
    Font *font;
    
    float upperPanelHeight;
    float lowerPanelHeight;
    float upperPanelDelta;
    float lowerPanelDelta;
    
    float musicVolume;
    float effectsVolume;
    
    float _displayMusicVolume;
    float _displayEffectsVolume;
    
    BOOL doorsOpen;
    BOOL menuActive;
    
    Emitter *emitter;
}

@end
