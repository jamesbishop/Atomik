//
//  CreditsScene.m
//  Atomik
//
//  Created by James on 11/11/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "FinishScene.h"

@interface FinishScene (Private)
// Define any private methods.
@end

@implementation FinishScene

- (id)init {
	if(self = [super init]) {
        
#ifdef DEBUG
        //NSLog(@"- Loading Finish Scene ...");
#endif
        
		// Get the instance of all our of game engine managers.
		_sceneManager = [SceneManager sharedSceneManager];
		_textureManager = [TextureManager sharedTextureManager];
        _imageManager = [ImageManager sharedImageManager];
		_soundManager = [SoundManager sharedSoundManager];
        _gameManager = [GameManager sharedGameManager];
        _networkManager = [NetworkManager sharedNetworkManager];
        _configManager = [ConfigManager sharedConfigManager];
        _progressManager = [ProgressManager sharedProgressManager];
        
        _sceneFadeSpeed = 1.0f;
        sceneAlpha = 1.0f;
		
        [_sceneManager setGlobalAlpha:sceneAlpha];
		
		background = [[Image alloc] initWithImage:@"Stage_Lite" width:_width height:_height];
        
        [_soundManager loadMusicWithKey:FINISH_LOOP_KEY musicFile:@"Menu_Scene.mp3"];
        [_soundManager setMusicVolume:0.0f];
        
        upperPanelHeight = (_centreY - UPPER_PANEL_LIP_HEIGHT);
        lowerPanelHeight = (_centreY - LOWER_PANEL_LIP_HEIGHT);
        
        upperPanelDelta = 0.0f;
        lowerPanelDelta = 0.0f;
        
        musicVolume = 0.0f;
        effectsVolume = 0.0f;
        
        doorsOpen = NO;
        
		nextSceneKey = nil;
		[self setSceneState:kSceneState_TransitionIn];
	}
	return self;
}

- (void)update:(GLfloat)delta {
	
	switch (sceneState) {
		case kSceneState_Running:
            
            
			break;
			
		case kSceneState_TransitionOut:
            
            // Adjust the alpha of all the components in the scene.
            [_sceneManager setGlobalAlpha:sceneAlpha];
			
            // Adjust the music volume for the current scene.
            [_soundManager setMusicVolume:musicVolume];
			
			if(!doorsOpen) {
                // If the scene being transitioned to does not exist then transition
                // this scene back in and set the key for the net scene in sequence.
				if(![_sceneManager setCurrentSceneToSceneWithKey:nextSceneKey]) {
                    sceneState = kSceneState_TransitionIn;
				}
                
                [_soundManager stopMusic];
                
			} else {
                // The doors are still open, so we need to initiate close sequence.
                if(upperPanelDelta > 0.0f) {
                    upperPanelDelta -= (UPPER_PANEL_DELTA(upperPanelHeight) * PANEL_OPEN_SPEED_FAST);
                    lowerPanelDelta -= (LOWER_PANEL_DELTA(lowerPanelHeight) * PANEL_OPEN_SPEED_FAST);
                    if(upperPanelDelta < 0.0f) upperPanelDelta = 0.0f;
                    if(lowerPanelDelta < 0.0f) lowerPanelDelta = 0.0f;
                    
                    musicVolume -= FRAME_DELTA;
                    
                } else {
                    doorsOpen = NO;
                }
            }
			
			break;
			
		case kSceneState_TransitionIn:
            
            // Adjust the alpha of all the components in the scene.
            [_sceneManager setGlobalAlpha:sceneAlpha];
            
            // Adjust the music volume for the current scene.
            [_soundManager setMusicVolume:musicVolume];
            
            if(![_soundManager isMusicPlaying]) {
                [_soundManager playMusicWithKey:FINISH_LOOP_KEY timesToRepeat:-1];
            }
            
            // Detect if this is the first time this scene has been executed.
            if(upperPanelDelta < upperPanelHeight) {
                upperPanelDelta += (UPPER_PANEL_DELTA(upperPanelHeight) * PANEL_OPEN_SPEED_FAST);
                lowerPanelDelta += (LOWER_PANEL_DELTA(lowerPanelHeight) * PANEL_OPEN_SPEED_FAST);
                if(upperPanelDelta < 0.0f) upperPanelDelta = 0.0f;
                if(lowerPanelDelta < 0.0f) lowerPanelDelta = 0.0f;
                
                musicVolume += FRAME_DELTA;
                
            } else {
                doorsOpen = YES;
                sceneState = kSceneState_Running;
            }
            
			break;
			
		default:
			break;
	}
	
}

- (void)setSceneState:(uint)state {
	sceneState = state;
	if(sceneState == kSceneState_TransitionOut) {
		sceneAlpha = 1.0f;
	}
	if(sceneState == kSceneState_TransitionIn) {
		sceneAlpha = 1.0f;
	}
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView *)view {
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(doorsOpen) {
        [_soundManager playSoundWithKey:MENU_SELECT_KEY];
        
        [self transitionToSceneWithKey:MENU_SCENE_KEY];
    }
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)transitionToSceneWithKey:(NSString*)key {
    nextSceneKey = key;
    [self setSceneState:kSceneState_TransitionOut];
}

- (void)render {
    // Display the back image, which is the company logo in the scene.
	[background renderAtPoint:CGPointMake(_centreX, _centreY) centerOfImage:YES];
    
    // Display the scene doors, which should be re-factored to the abstract layer.
    [[_imageManager getImageWithName:UPPER_DOOR_KEY] renderAtPoint:CGPointMake(0, _centreY + upperPanelDelta) centerOfImage:NO];
    [[_imageManager getImageWithName:LOWER_DOOR_KEY] renderAtPoint:CGPointMake(0, 0.0f - lowerPanelDelta) centerOfImage:NO];
}

- (void)dealloc {
	[super dealloc];
	[background release];
}

@end
