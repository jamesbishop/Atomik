//
//  GameControl.m
//
//  Created by James Bishop on 6/16/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "GameControl.h"

@implementation GameControl

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - GameControl -> touchesBegan ...");
    
    GameManager *_gameManager = [GameManager sharedGameManager];

    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];

    // Touches are not handled in the same way and rendering.
    int _height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (_height - location.y);
    
    int entities = [[_gameManager molecules] count];
    for(int i=0; i < entities; i++) {
        AbstractEntity *entity = (AbstractEntity*)[[[_gameManager molecules] objectAtIndex:i] retain];
        if(CGRectContainsPoint([entity bounds], location)) {
            if([entity state] == kEntity_Alive) {
                [entity setInteraction:kInteraction_Drag];
                break;
            }
        }
        [entity release];
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - GameControl -> touchesMoved ...");
    
    GameManager *_gameManager = [GameManager sharedGameManager];
    
    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];

    // Touches are not handled in the same way and rendering.
    int _height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (_height - location.y);
    
    int entities = [[_gameManager molecules] count];
    for(int i=0; i < entities; i++) {
        AbstractEntity *entity = (AbstractEntity*)[[[_gameManager molecules] objectAtIndex:i] retain];
        if([entity interaction] == kInteraction_Drag) {
            [entity touchesMoved:touches withEvent:event view:view];
        }
        [entity release];
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - GameControl -> touchesEnded ...");

    GameManager *_gameManager = [GameManager sharedGameManager];

    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];

    // Touches are not handled in the same way and rendering.
    int _height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (_height - location.y);
    
    int entities = [[_gameManager molecules] count];
    for(int i=0; i < entities; i++) {
        AbstractEntity *entity = (AbstractEntity*)[[[_gameManager molecules] objectAtIndex:i] retain];
        if([entity interaction] == kInteraction_Drag) {
            [entity touchesEnded:touches withEvent:event view:view];
        }
        [entity release];
    }
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"      - GameControl -> touchesCancelled ...");
    
    GameManager *_gameManager = [GameManager sharedGameManager];

    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];

    // Touches are not handled in the same way and rendering.
    int _height = [[UIScreen mainScreen] bounds].size.height;
    location.y = (_height - location.y);
    
    int entities = [[_gameManager molecules] count];
    for(int i=0; i < entities; i++) {
        AbstractEntity *entity = (AbstractEntity*)[[[_gameManager molecules] objectAtIndex:i] retain];
        [entity touchesCancelled:touches withEvent:event view:view];
        [entity release];
    }
}

@end
