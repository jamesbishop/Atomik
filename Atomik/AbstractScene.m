//
//  AbstractScene.m
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import "AbstractScene.h"

@implementation AbstractScene

@synthesize sceneState;
@synthesize sceneAlpha;
@synthesize _width;
@synthesize _height;
@synthesize _centreX;
@synthesize _centreY;

- (id)init {
	if(self = [super init]) {
        _width = [[UIScreen mainScreen] bounds].size.width;
        _height = [[UIScreen mainScreen] bounds].size.height;
        _centreX = (int)(_width / 2);
        _centreY = (int)(_height / 2);
    }
    return self;
}

- (void)sceneStartsWithDoorsClosed {
}
    
- (void)sceneStartsDoorsAreOpen {
}
    
- (void)sceneFinishesDoorsAreOpen {
}
    
- (void)sceneFinishesDoorsAreClosed {
}
    
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)transitionToSceneWithKey:(NSString*)key {
}

- (void)update:(GLfloat)delta {
}

- (void)render {
}

- (void)dealloc {
    [super dealloc];
}

@end