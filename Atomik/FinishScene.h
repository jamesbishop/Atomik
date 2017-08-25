//
//  FinishScene.h
//  Atomik
//
//  Created by James on 4/15/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "AbstractScene.h"

@interface FinishScene : AbstractScene {
	Image *background;
    
    float upperPanelHeight;
    float lowerPanelHeight;
    float upperPanelDelta;
    float lowerPanelDelta;
    
    float musicVolume;
    float effectsVolume;
    
    BOOL doorsOpen;
}

@end