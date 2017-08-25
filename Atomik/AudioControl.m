//
//  AudioControl.m
//  Atomik
//
//  Created by James on 3/15/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "AudioControl.h"

@interface AudioControl (Private)
- (void)updateButtons:(CGPoint)position;
@end

@implementation AudioControl

@synthesize sliders;
@synthesize buttons;

- (id)init {
    if (self = [super init]) {
        _configManager = [ConfigManager sharedConfigManager];
    }
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - AudioControl -> touchesBegan ...");
    CGPoint location = [super resolve:touches withEvent:event view:view];
    
    UILocation *position = [[UILocation alloc] initWithLocation:location];
    [sliders makeObjectsPerformSelector:@selector(touchBegan:) withObject:position];
    
    // Delegate the menu handling updates to another handler.
    [self updateButtons:location];
}
    
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - AudioControl -> touchesMoved ...");
    
    // Get the details of all the touches for this view.
    CGPoint location = [super resolve:touches withEvent:event view:view];
    
    UILocation *position = [[UILocation alloc] initWithLocation:location];
    [sliders makeObjectsPerformSelector:@selector(touchMoved:) withObject:position];
    
    // Delegate the menu handling updates to another handler.
    [self updateButtons:location];
}
    
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - AudioControl -> touchesEnded ...");
    
    // Get the details of all the touches for this view.
    CGPoint location = [super resolve:touches withEvent:event view:view];
    
    UILocation *position = [[UILocation alloc] initWithLocation:location];
    [sliders makeObjectsPerformSelector:@selector(touchEnded:) withObject:position];
    
    // Delegate the menu handling updates to another handler.
    [self updateButtons:location];
}
    
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - AudioControl -> touchesCancelled ...");
    
    // Get the details of all the touches for this view.
    CGPoint location = [super resolve:touches withEvent:event view:view];
    
    UILocation *position = [[UILocation alloc] initWithLocation:location];
    [sliders makeObjectsPerformSelector:@selector(touchCancel:) withObject:position];
    
    // Delegate the menu handling updates to another handler.
    [self updateButtons:location];
}

- (void)updateButtons:(CGPoint)position {
    active = nil;
    
    for(int i=0; i < buttons.count; i++) {
        UIFadeButton *button = [buttons objectAtIndex:i];
        if(CGRectContainsPoint([button bounds], position)) {
            active = button;
            break;
        }
    }
}

- (void)reset {
    for(int i=0; i < buttons.count; i++) {
        UIFadeButton *button = [buttons objectAtIndex:i];
        [button setState:0];
    }
    
    active = nil;
}

- (UIFadeButton*)getActiveButton {
    return active;
}

@end
