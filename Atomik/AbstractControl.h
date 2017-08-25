//
//  AbstractControl.h
//
//  Created by James Bishop on 27/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import <Foundation/Foundation.h>

#import "GameManager.h"
#import "SoundManager.h"
#import "ConfigManager.h"
#import "UIFadeButton.h"

@interface AbstractControl : NSObject {
    
}

- (CGPoint)resolve:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
    
// Selector that enables a touchesBegan events location to be passed into a control.  
// Each touch location is a CGPoint which has been encoded from the designated scene.
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;

@end
