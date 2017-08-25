//
//  ViewController.h
//
//  Created by James Bishop on 01/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <OpenGLES/EAGL.h>
#import <OpenGLES/ES1/gl.h>
#import <OpenGLES/ES1/glext.h>

#import "Constants.h"

#import "SceneManager.h"
#import "TextureManager.h"
#import "SoundManager.h"
#import "GameManager.h"

#import "Image.h"
#import "SpriteSheet.h"
#import "AbstractScene.h"
#import "LogoScene.h"
#import "MenuScene.h"
#import "AudioScene.h"
#import "RulesScene.h"
#import "StageScene.h"
#import "DailyScene.h"
#import "GameScene.h"
#import "ScoreScene.h"
#import "CreditsScene.h"
#import "PurchaseScene.h"
#import "FinishScene.h"

#ifdef LITE_VERSION
#else
#endif

@class EAGLView;

@interface GLViewController : UIViewController <UIAccelerometerDelegate> {
	/* State to define if OGL has been initialised or not */
	BOOL glInitialised;
	
	// Grab the bounds of the screen
	CGRect screenBounds;
	
	// Accelerometer fata
	UIAccelerationValue _accelerometer[3];
	
	// Shared game state
	SceneManager *_sceneManager;
	
	// Shared resource manager
	TextureManager *_resourceManager;
	
	// Shared sound manager
	SoundManager *_soundManager;
	
	// Shared game manager
	GameManager *_gameManager;
}

- (id)initWithFrame:(CGRect)frame;

- (void)loadView;

- (void)initOpenGL;
- (void)renderScene;
- (void)updateScene:(GLfloat)delta;
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;

@end
