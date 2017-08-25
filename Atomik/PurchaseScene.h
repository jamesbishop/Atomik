//
//  PurchaseScene.h
//  Atomik
//
//  Created by James on 2/9/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "AbstractScene.h"
#import "PurchaseConfig.h"
#import "PurchaseControl.h"

@interface PurchaseScene : AbstractScene {
    PurchaseConfig *config;
    PurchaseControl *control;
    
    NSArray *_products;
    
	Image *background;
    Font *font;
    
    NSMutableArray *buttons;

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
