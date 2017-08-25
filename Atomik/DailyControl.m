//
//  DailyControl.m
//  Atomik
//
//  Created by James on 6/10/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "DailyControl.h"

@interface DailyControl (Private)
- (void)update:(CGPoint)position;
@end

@implementation DailyControl

- (id)init {
    if (self = [super init]) {
        _configManager = [ConfigManager sharedConfigManager];
    }
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - StageControl -> touchesBegan ...");
    
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
    //NSLog(@"      - StageControl -> touchesMoved ...");
    
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
    //NSLog(@"      - StageControl -> touchesEnded ...");
    
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
    //NSLog(@"      - StageControl -> touchesCancelled ...");
    
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
    
    DailyConfig *config = [_configManager getDailyConfig];
    for(int i=0; i < [config buttons].count; i++) {
        UIFadeButton *button = [[config buttons] objectAtIndex:i];
        if(CGRectContainsPoint([button bounds], position)) {
            active = button;
            break;
        }
    }
}

- (void)reset {
    DailyConfig *config = [_configManager getDailyConfig];
    
    for(int i=0; i < [config buttons].count; i++) {
        UIFadeButton *button = [[config buttons] objectAtIndex:i];
        [button setState:0];
    }
    
    active = nil;
}

- (UIFadeButton*)getActiveButton {
    return active;
}

@end
