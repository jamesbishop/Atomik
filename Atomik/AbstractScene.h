//
//  AbstractScene.h
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "AbstractControl.h"
#import "SceneManager.h"
#import "TextureManager.h"
#import "ImageManager.h"
#import "SoundManager.h"
#import "GameManager.h"
#import "DeviceManager.h"
#import "NetworkManager.h"
#import "ConfigManager.h"
#import "ProgressManager.h"
#import "Image.h"
#import "SpriteSheet.h"
#import "Animation.h"
#import "Font.h"
#import "Constants.h"

#define UPPER_PANEL_DELTA(__HEIGHT__)       (__HEIGHT__ / FRAME_RATE)
#define LOWER_PANEL_DELTA(__HEIGHT__)       (__HEIGHT__ / FRAME_RATE)

#define PANEL_OPEN_SPEED_SLOW       0.55f
#define PANEL_OPEN_SPEED_FAST       1.25f

#define UPPER_PANEL_LIP_HEIGHT      35.0f
#define LOWER_PANEL_LIP_HEIGHT      34.0f


// This is an abstract class which contains the basis for any game scene which is going
// to be used.  A game scene is a self contained class which is responsible for updating
// the logic and rendering the screen for the current scene.  It is simply a way to
// encapsulate a specific scenes code in a single class.
//
// The Director class controls which scene is the current scene and it is this scene which
// is updated and rendered during the game loop.
//
@interface AbstractScene : NSObject {
    ConfigManager   *_configManager;
	SceneManager    *_sceneManager;
	TextureManager  *_textureManager;
    ImageManager    *_imageManager;
	SoundManager    *_soundManager;
	GameManager		*_gameManager;
    NetworkManager  *_networkManager;
    ProgressManager *_progressManager;
	CGRect          _screenBounds;
	uint            sceneState;
	float           sceneAlpha;
	NSString        *nextSceneKey;
    float           _sceneFadeSpeed;
    int             _width;
    int             _height;
    int             _centreX;
    int             _centreY;
    
    float           _doorDelayDelta;
}

#pragma mark -
#pragma mark Properties

// This property allows for the scenes state to be altered
@property (nonatomic, assign) uint sceneState;

// This property allows for the scenes alpha to be changed.  Any image which is being rendered
// uses the Director to get the current scene and from this it will take the current scenes
// alpha and use this when calculating its own alpha.  This allows you to fade an entire scene
// just by changing the scenes alpha and not the individual alpha of each image
@property (nonatomic, assign) GLfloat sceneAlpha;

// We use the width/height properties of the device in every single scene. Rather than query
// the device class bounds every time, simply store them in an instance variable for usage.
@property (nonatomic, assign) int _width;
@property (nonatomic, assign) int _height;
@property (nonatomic, assign) int _centreX;
@property (nonatomic, assign) int _centreY;

#pragma mark -
#pragma mark Selectors

// These methods are used to control the enter/exit scene sequences from the main controller.
- (void)sceneStartsWithDoorsClosed;
- (void)sceneStartsDoorsAreOpen;
- (void)sceneFinishesDoorsAreOpen;
- (void)sceneFinishesDoorsAreClosed;
    
// Selector that enables a touchesBegan events location to be passed into a scene.  |aTouchLocation| is
// a CGPoint which has been encoded into an NSString
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;

// Selector that transitions from this scene to the scene with the key specified.  This allows the current
// scene to perform a transition action before the current scene within the Director is changed.
- (void)transitionToSceneWithKey:(NSString*)key;

// Selector to update the scenes logic using |aDelta| which is passe in from the game loop
- (void)update:(GLfloat)delta;

// Selector which renders the scene
- (void)render;

@end
