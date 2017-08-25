//
//  RulesScene.h
//  Atomik
//
//  Created by James on 4/16/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "AbstractScene.h"

@interface RulesScene : AbstractScene {
    Image *touchScreen;
    NSMutableArray *rules;
    
    float upperPanelHeight;
    float lowerPanelHeight;
    float upperPanelDelta;
    float lowerPanelDelta;
    
    float musicVolume;
    float effectsVolume;
    
    BOOL doorsOpen;
    BOOL menuActive;
    
    int ruleIndex;
    int showIndex;
}

@property (nonatomic, retain) NSMutableArray *rules;

@end
