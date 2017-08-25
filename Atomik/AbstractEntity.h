//
//  AbstractEntity.h
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#import "SoundManager.h"
#import "Common.h"
#import "Constants.h"
#import "Animation.h"
#import "Image.h"
#import "Emitter.h"
#import "ParticleEmitter.h"

@class GameScene;

// Entity States
enum entityState {
	kEntity_Idle = 0,
	kEntity_Alive = 1,
	kEntity_Dying = 2,
	kEntity_Dead = 3
};

// Entity Directions 
enum entityDirection {
    kDirection_None = 0,
	kDirection_Up = 1,
	kDirection_Right = 2,
	kDirection_Down = 3,
	kDirection_Left = 4
};

enum entityVisibility {
    kVisibility_Hide = 0,
    kVisibility_Show = 1
};

enum entityInteraction {
    kInteraction_None = 0,
    kInteraction_Drag = 1,
    kInteraction_Drop = 2,
    kInteraction_Tap = 3,
    kInteraction_UnTap = 4
};

enum entityTransition {
    kTransition_None = 0,
    kTransition_Success = 1,
    kTransition_Failure = 2,
};

@interface AbstractEntity : NSObject {
    NSString *name;
    Image *graphic;
	GLuint state;
    GLuint direction;
    GLuint visibility;
    GLuint interaction;
    GLuint transition;
    GLfloat speed;
    GLfloat delay;
    CGPoint position;
    CGRect bounds;
    GLfloat sensitivity;
}

@property (nonatomic, assign) NSString *name;
@property (nonatomic, assign) Image *graphic;
@property (nonatomic, assign) GLuint state;
@property (nonatomic, assign) GLuint direction;
@property (nonatomic, assign) GLuint visibility;
@property (nonatomic, assign) GLuint interaction;
@property (nonatomic, assign) GLuint transition;
@property (nonatomic, assign) GLfloat speed;
@property (nonatomic, assign) GLfloat delay;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) GLfloat sensitivity;

- (id)initWithImage:(Image*)image atPoint:(CGPoint)point;

- (void)updateBounds;

- (void)update:(float)delta;
- (void)render;

// Selector that enables a touchesBegan events location to be passed into a control.  
// Each touch location is a CGPoint which has been encoded from the designated scene.
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;

@end
