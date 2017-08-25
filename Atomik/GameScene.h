//
//  GameScene.h
//
//  Created by James Bishop on 4/24/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "AbstractScene.h"
#import "GameControl.h"
#import "UIHelper.h"

@interface GameScene : AbstractScene {
    GameControl *control;
    
    Font *font;
    
    float upperPanelHeight;
    float lowerPanelHeight;
    float upperPanelDelta;
    float lowerPanelDelta;
    
    float musicVolume;
    float effectsVolume;
    
    BOOL doorsOpen;
    BOOL isSceneReady;
    
    int _score;
    
    float _powerupAxisX;
    float _powerupDelta;
}

@end
