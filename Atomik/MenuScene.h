//
//  MenuScene.h
//
//  Created by James Bishop on 4/14/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AbstractScene.h"
#import "MenuControl.h"

#define BUTTON_WIDTH    200.0f
#define BUTTON_HEIGHT   50.0f

#define MENU_TOP_BAR    75.0f
#define MENU_SPACING    45.0f
#define MENU_OPTIONS    5

@interface MenuScene : AbstractScene {
    MenuConfig *config;
    MenuControl *control;
    
	Image *background;
    Image *menuTitle;
    Emitter *emitter;
    
    NSMutableArray *inactive;
    NSMutableArray *active;
    
    float upperPanelHeight;
    float lowerPanelHeight;
    float upperPanelDelta;
    float lowerPanelDelta;
    
    float musicVolume;
    float effectsVolume;
    
    BOOL doorsOpen;
    BOOL menuActive;
}

@end
