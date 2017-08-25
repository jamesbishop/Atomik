//
//  LogoScene.m
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import "LogoScene.h"

@interface LogoScene (Private)
- (void)clampVolumeToSettings;
@end

@implementation LogoScene

- (id)init {
	if(self = [super init]) {
        
#ifdef LITE_VERSION
#ifdef DEBUG
        //NSLog(@"***********************************");
        //NSLog(@"******* Running LITE Version ******");
        //NSLog(@"***********************************");
#endif
#endif
        
#ifdef DEBUG
        //NSLog(@"- Loading Logo Scene ...");
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
        
        // Check the game registration information is correct.
        [_progressManager checkGameRegistration];
        [_progressManager loadProgressData];
        
        // Preload the mandatory game data for all game scenes.
        [_gameManager init];
        
        _sceneFadeSpeed = 1.0f;
        sceneAlpha = 0.0f;
        
        [_sceneManager setGlobalAlpha:sceneAlpha];
		
        background = [[Image alloc] initWithImage:@"Logo_Scene" width:_width height:_height];

        [_soundManager loadSoundWithKey:BLAST_AUDIO_KEY soundFile:@"Blast_Door.mp3"];

        Image *door = [[Image alloc] initWithImage:@"Upper_Door" width:_width height:_centreY];
        [_imageManager addImage:door andKey:UPPER_DOOR_KEY];
        [door release];
        
        door = [[Image alloc] initWithImage:@"Lower_Door" width:_width height:_centreY];
        [_imageManager addImage:door andKey:LOWER_DOOR_KEY];
        [door release];

        // Load the particle emitter textures for the sub-system.
        [_imageManager addImageWithName:@"Texture_1_(64x64).png" andKey:PARTICLE_EMITTER_ROUND];
        [_imageManager addImageWithName:@"Texture_2_(64x64).png" andKey:PARTICLE_EMITTER_SPOTLITE];
        [_imageManager addImageWithName:@"Texture_3_(64x64).png" andKey:PARTICLE_EMITTER_STAR];
        [_imageManager addImageWithName:@"Texture_4_(64x64).png" andKey:PARTICLE_EMITTER_SNOWFLAKE];
        
        [_soundManager loadMusicWithKey:LOGO_LOOP_KEY musicFile:@"Logo_Scene.mp3"];
        [_soundManager setMusicVolume:musicVolume];
      
        upperPanelHeight = _centreY;    // 240 or 284
        lowerPanelHeight = _centreY;    // 240 or 284
        
        upperPanelDelta = upperPanelHeight;
        lowerPanelDelta = lowerPanelHeight;

        musicVolume = 0.0f;
        effectsVolume = 0.0f;
		
        doorsOpen = YES;
        sceneReady = NO;

		nextSceneKey = nil;
		[self setSceneState:kSceneState_TransitionIn];
	}
	return self;
}

- (void)update:(GLfloat)delta {
	
	switch (sceneState) {
		case kSceneState_Running:

            duration += delta;
            
            if(duration > SCENE_DURATION) {
                [self transitionToSceneWithKey:MENU_SCENE_KEY];
            }
            
			break;
			
		case kSceneState_TransitionOut:

            if(!doorsOpen) {                
                // If the scene being transitioned to does not exist then transition
                // this scene back in and set the key for the net scene in sequence.
				if(![_sceneManager setCurrentSceneToSceneWithKey:nextSceneKey]) {
                    sceneState = kSceneState_TransitionIn;
				}
                
			} else {
                // The doors are still open, so we need to initiate close sequence.
                if(upperPanelDelta > 0.0f) {
                    upperPanelDelta -= (UPPER_PANEL_DELTA(upperPanelHeight) * PANEL_OPEN_SPEED_SLOW);
                    lowerPanelDelta -= (LOWER_PANEL_DELTA(lowerPanelHeight) * PANEL_OPEN_SPEED_SLOW);
                    if(upperPanelDelta < 0.0f) upperPanelDelta = 0.0f;
                    if(lowerPanelDelta < 0.0f) lowerPanelDelta = 0.0f;

                    // Fade the music in with with the scene transition and graphics.
                    musicVolume -= FRAME_DELTA;
                    effectsVolume -= FRAME_DELTA;
                    
                    [self clampVolumeToSettings];
                    
                } else {
                    doorsOpen = NO;
                }
            }

			break;
			
		case kSceneState_TransitionIn:
			// I'm not using the delta value here as the large map being loaded causes
            // the first delta to be passed in to be very big which takes the alpha
            // to over 1.0 immediately, so I've got a fixed delta for the fade in.
            sceneAlpha += _sceneFadeSpeed * 0.02f;

            // Perform clipping on the music volume, to prevent any inconsistences.
			if(sceneAlpha >= 1.0f) {
                sceneAlpha = 1.0f;
				sceneState = kSceneState_Running;
			}
			
            // Decrease the alpha value across the entire scene.
            [_sceneManager setGlobalAlpha:sceneAlpha];
			
            // Set our game volume controls to pre-settings.
            musicVolume += FRAME_DELTA;
            effectsVolume += FRAME_DELTA;
            
            [self clampVolumeToSettings];
            
            // Detect if this is the first time this scene has been executed.
            if(![_soundManager isMusicPlaying]) {
                [_soundManager playMusicWithKey:LOGO_LOOP_KEY timesToRepeat:0];
            }
            
            sceneReady = YES;
            
			break;
			
		default:
			break;
	}
	
}

- (void)clampVolumeToSettings {
    ProgressData *progress = [_progressManager getProgressData];
    
    if(musicVolume > [progress musicVolume]) {
        musicVolume = [progress musicVolume];
    }
    if(effectsVolume > [progress effectsVolume]) {
        effectsVolume = [progress effectsVolume];
    }
    
    if(musicVolume < 0.0f) {
        musicVolume = 0.0f;
    }
    if(effectsVolume < 0.0f) {
        effectsVolume = 0.0f;
    }

    // Adjust the music volume for the scene as well.
    [_soundManager setMusicVolume:musicVolume];
    [_soundManager setFxVolume:effectsVolume];
}

- (void)setSceneState:(uint)state {
	sceneState = state;
	if(sceneState == kSceneState_TransitionOut) {
		sceneAlpha = 1.0f;
	}
	if(sceneState == kSceneState_TransitionIn) {
		sceneAlpha = 0.0f;
	}
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView *)view {
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    duration = SCENE_DURATION;
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)transitionToSceneWithKey:(NSString*)key {
    // Remove the sounds associated with logo scene as they are
    // no longer needed at any point during the game sequence.
    [_soundManager stopMusic];
    [_soundManager removeMusicWithKey:LOGO_LOOP_KEY];
    
    [_soundManager playSoundWithKey:BLAST_AUDIO_KEY];

    nextSceneKey = key;
    [self setSceneState:kSceneState_TransitionOut];
}

- (void)render {
    // If the scene is not ready, then do not render anything yet.
    if(!sceneReady) {
        return;
    }
    
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
