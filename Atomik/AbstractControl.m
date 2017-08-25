//
//  AbstractControl.m
//
//  Created by James Bishop on 27/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import "AbstractControl.h"

@implementation AbstractControl

- (id)init {
	if(self = [super init]) {
        // Constructor initialisation.
    }
    return self;
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (CGPoint)resolve:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    // Touches are not handled in the same way and rendering.
    int _height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (_height - location.y);
    
    return location;
}

@end
