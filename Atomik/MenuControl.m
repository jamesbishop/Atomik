//
//  MenuControl.m
//
//  Created by James Bishop on 12/17/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "MenuControl.h"

@implementation MenuControl

- (id)init {
    if (self = [super init]) {
        _configManager = [ConfigManager sharedConfigManager];
    }
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - MenuControl -> touchesBegan ...");
    
    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    // Touches are not handled in the same way and rendering.
    int _height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (_height - location.y);
    
    // Delegate the menu handling updates to another handler.
    [self update:location];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - MenuControl -> touchesMoved ...");
    
    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    // Touches are not handled in the same way and rendering.
    int _height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (_height - location.y);
    
    // Delegate the menu handling updates to another handler.
    [self update:location];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - MenuControl -> touchesEnded ...");
    
    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    // Touches are not handled in the same way and rendering.
    int _height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (_height - location.y);
    
    // Delegate the menu handling updates to another handler.
    [self update:location];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - MenuControl -> touchesCancelled ...");
    
    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    // Touches are not handled in the same way and rendering.
    int _height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (_height - location.y);
    
    // Delegate the menu handling updates to another handler.
    [self update:location];
}

- (void)update:(CGPoint)position {
    active = nil;
    
    MenuConfig *config = [_configManager getMenuConfig];
    for(int i=0; i < [[config buttons] count]; i++) {
        UIFadeButton *button = [[config buttons] objectAtIndex:i];
        if(CGRectContainsPoint([button bounds], position)) {
            active = button;
            break;
        }
    }
}

- (void)reset {
    active = nil;
}

- (UIFadeButton*)getActiveButton {
    return active;
}

@end
