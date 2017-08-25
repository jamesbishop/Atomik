//
//  ViewController.m
//
//  Created by James Bishop on 01/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import "GLViewController.h"
#import "Common.h"
#import "EAGLView.h"

@implementation GLViewController

#pragma mark - 
#pragma mark Dealloc

- (void)dealloc {
	[_soundManager shutdownSoundManager];
	[_sceneManager dealloc];
	[_resourceManager dealloc];
    [super dealloc];
}

#pragma mark -
#pragma mark Initialize the game

- (id)initWithFrame:(CGRect)frame {
	
	if(self == [super init]) {	
		// Get the shared instance from the SingletonGameState class.  This will
		// provide us with a static class that can track game and OpenGL state.
		_sceneManager = [SceneManager sharedSceneManager];
		_resourceManager = [TextureManager sharedTextureManager];
		_soundManager = [SoundManager sharedSoundManager];
		_gameManager = [GameManager sharedGameManager];
		
        screenBounds = frame;
        
		// Initialize the OpenGL content and renderer settings.
		[self initOpenGL];
		
		// Initialize the game scenes and add them to the Scene Manager.
		AbstractScene *scene = [[LogoScene alloc] init];
		[_sceneManager addSceneWithKey:LOGO_SCENE_KEY scene:scene];
        [scene release];

        scene = [[MenuScene alloc] init];
		[_sceneManager addSceneWithKey:MENU_SCENE_KEY scene:scene];
        [scene release];

        scene = [[StageScene alloc] init];
		[_sceneManager addSceneWithKey:STAGE_SCENE_KEY scene:scene];
        [scene release];

        scene = [[DailyScene alloc] init];
		[_sceneManager addSceneWithKey:DAILY_SCENE_KEY scene:scene];
        [scene release];
        
        scene = [[AudioScene alloc] init];
		[_sceneManager addSceneWithKey:AUDIO_SCENE_KEY scene:scene];
        [scene release];
        
        scene = [[RulesScene alloc] init];
		[_sceneManager addSceneWithKey:RULES_SCENE_KEY scene:scene];
        [scene release];

        scene = [[GameScene alloc] init];
		[_sceneManager addSceneWithKey:GAME_SCENE_KEY scene:scene];
        [scene release];

        scene = [[ScoreScene alloc] init];
		[_sceneManager addSceneWithKey:SCORE_SCENE_KEY scene:scene];
        [scene release];

        scene = [[CreditsScene alloc] init];
		[_sceneManager addSceneWithKey:CREDITS_SCENE_KEY scene:scene];
        [scene release];

        scene = [[PurchaseScene alloc] init];
		[_sceneManager addSceneWithKey:PURCHASE_SCENE_KEY scene:scene];
        [scene release];

        scene = [[FinishScene alloc] init];
		[_sceneManager addSceneWithKey:FINISH_SCENE_KEY scene:scene];
        [scene release];

		// Make sure glInitialised is set to NO so that OpenGL gets initialised when the first scene is rendered
		glInitialised = NO;
		
		// Set the initial game state
		[_sceneManager setCurrentSceneToSceneWithKey:LOGO_SCENE_KEY];
		[[_sceneManager currentScene] setSceneState:kSceneState_TransitionIn];
	}
	return self;
}

- (void)loadView {
    //NSLog(@"LOAD VIEW!");
}

#pragma mark -
#pragma mark Initialize OpenGL settings

- (void)initOpenGL {
    
#ifdef DEBUG
    // Debugging info to show what type of device and size we are operating with
    UIScreen *mainScreen = [UIScreen mainScreen];
    NSLog(@"Device: Bounds->[%@], Resolution->[%@], Scale->[%f], NativeScale->[%.0f] ...",
          NSStringFromCGRect(mainScreen.bounds), mainScreen.coordinateSpace, mainScreen.scale, mainScreen.nativeScale);
#endif
    
	// Switch to GL_PROJECTION matrix mode and reset the current matrix with the identity matrix
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
    // Setup Ortho for the current matrix mode.  This describes a transformation that is applied to
    // the projection.  For our needs we are defining the fact that 1 pixel on the screen is equal to
    // one OGL unit by defining the horizontal and vertical clipping planes to be from 0 to the views
    // dimensions.  The far clipping plane is set to -1 and the near to 1.
    glOrthof(0, screenBounds.size.width, 0, screenBounds.size.height, -1, 1);
	
	// Switch to GL_MODELVIEW so we can now draw our objects
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	// Setup how textures should be rendered i.e. how a texture with alpha should be rendered ontop of
	// another texture.
	glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_BLEND_SRC);
	
	// We are not using the depth buffer in our 2D game so depth testing can be disabled.  If depth
	// testing was required then a depth buffer would need to be created as well as enabling the depth
	// test
	glDisable(GL_DEPTH_TEST);
	
	// Set the colour to use when clearing the screen with glClear
	glClearColor(0.0f, 0.0f, 0.0f, 0.0f);
	
	// Mark OGL as initialised
	glInitialised = YES;
}

#pragma mark -
#pragma mark Update the game scene logic

- (void)updateScene:(GLfloat)delta {	
	// Update the game logic based for the current scene
	[[_sceneManager currentScene] update:delta];
}

#pragma mark -
#pragma mark Render the scene

- (void)renderScene {
    
    // Update the screen scaling due to the introduction of Apples retina display technology.
    const float SCALE = [_sceneManager graphicsScale];

	// Define the viewport.  Changing the settings for the viewport can allow you to scale the viewport
	// as well as the dimensions etc and so I'm setting it for each frame in case we want to change it
    glViewport(0, 0, (screenBounds.size.width * SCALE), (screenBounds.size.height * SCALE));
	
	// Clear the screen to our designated colour.
	glClear(GL_COLOR_BUFFER_BIT);
	
    // Delegate our rendering to the currently active scene.
	[[_sceneManager currentScene] render];
    
}

#pragma mark -
#pragma mark Touches

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"  - ViewController -> touchesBegan ...");
	[[_sceneManager currentScene] touchesBegan:touches withEvent:event view:view];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"  - ViewController -> touchesMoved ...");
	[[_sceneManager currentScene] touchesMoved:touches withEvent:event view:view];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"  - ViewController -> touchesEnded ...");
	[[_sceneManager currentScene] touchesEnded:touches withEvent:event view:view];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    //NSLog(@"  - ViewController -> touchesCancelled ...");
	[[_sceneManager currentScene] touchesCancelled:touches withEvent:event view:view];
}

@end
