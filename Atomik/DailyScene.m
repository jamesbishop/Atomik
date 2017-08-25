//
//  DailyScene.m
//  Atomik
//
//  Created by James on 6/9/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "DailyScene.h"

@interface DailyScene (Private)
- (void)updateMenu:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)clampVolumeToSettings;
- (void)renderNavigationButtons;
@end

@implementation DailyScene

- (id)init {
	if(self = [super init]) {
        
#ifdef DEBUG
        //NSLog(@"- Loading Daily Scene ...");
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
        
        [_configManager loadDailyConfigWithWidth:_width andHeight:_height];
        config = [_configManager getDailyConfig];
        
        background = [[Image alloc] initWithImage:[config sceneImage] width:_width height:_height];
		
        sceneTitle = (Image*)[[Image alloc] initWithImage:[config sceneTitle] width:_width height:64];
        
        font = [[Font alloc] initWithFontImageNamed:@"ObelixPro_Shadow_14" controlFile:@"ObelixPro_Shadow_14" scale:1.0f filter:GL_LINEAR];

        // Now we need to load the menu buttons into the image buffers
        buttons = [[NSMutableArray alloc] init];
        for(int i=0; i < [config buttons].count; i++) {
            UIFadeButton *button = (UIFadeButton*)[[config buttons] objectAtIndex:i];
            
            int width = [button bounds].size.width;
            int height = [button bounds].size.height;
            
            Image *image = (Image*)[[Image alloc] initWithImage:[button ID] width:width height:height];
            [_imageManager addImage:image andKey:[button ID]];
            [image release];
        }
        
        // Add the music files to our audio sub-system.
        [_soundManager loadMusicWithKey:DAILY_LOOP_KEY musicFile:[config sceneMusic]];
        
        // Add the sound files to our audio sub-system.
        [_soundManager loadSoundWithKey:MENU_SELECT_KEY soundFile:@"Menu_Select.mp3"];
        [_soundManager loadSoundWithKey:MENU_BACK_KEY soundFile:@"Menu_Back.mp3"];
        
        upperPanelHeight = (_centreY - UPPER_PANEL_LIP_HEIGHT);
        lowerPanelHeight = (_centreY - LOWER_PANEL_LIP_HEIGHT);
        
        upperPanelDelta = 0.0f;
        lowerPanelDelta = 0.0f;
        
        musicVolume = 0.0f;
        effectsVolume = 0.0f;
        
        doorsOpen = NO;
        levelLoaded = NO;
        
        control = [[DailyControl alloc] init];
        
        // Angles: 0=Right, 90=Down, 180=Left, 270=Up
        emitter = [[Emitter alloc] initParticleEmitterWithImageNamed:PARTICLE_EMITTER_SPOTLITE
                                                            position:Vector2fMake(_centreX, 290.0f)
                                              sourcePositionVariance:Vector2fMake(160, 160)
                                                               speed:1.0f
                                                       speedVariance:2.0f
                                                    particleLifeSpan:1.0f
                                            particleLifespanVariance:2.0f
                                                               angle:0.0f
                                                       angleVariance:360.0f
                                                             gravity:Vector2fMake(0.0f, -0.0f)
                                                          startColor:Color4fMake(1.00f, 1.00f, 1.00f, 1.00f)
                                                  startColorVariance:Color4fMake(0.00f, 0.00f, 0.00f, 0.00f)
                                                         finishColor:Color4fMake(0.25f, 1.00f, 1.00f, 1.00f)
                                                 finishColorVariance:Color4fMake(0.10f, 0.10f, 0.10f, 0.00f)
                                                        maxParticles:200
                                                        particleSize:10
                                                particleSizeVariance:10
                                                            duration:-1.0f
                                                       blendAdditive:YES];
        
        [emitter setActive:YES];

		nextSceneKey = nil;
		[self setSceneState:kSceneState_TransitionIn];
	}
	return self;
}

- (void)update:(GLfloat)delta {
	
    [emitter update:delta];
    
	switch (sceneState) {
		case kSceneState_Running:
            
			break;
			
		case kSceneState_TransitionOut:
            
            // **********************************************************************************************
            // SCENE FINISHES
            // **********************************************************************************************
            
            // Adjust the alpha of all the components in the scene.
            [_sceneManager setGlobalAlpha:sceneAlpha];
			
			if(!doorsOpen) {
                // If the scene being transitioned to does not exist then transition
                // this scene back in and set the key for the net scene in sequence.
				if(![_sceneManager setCurrentSceneToSceneWithKey:nextSceneKey]) {
                    sceneState = kSceneState_TransitionIn;
				}
                
                [self sceneFinishesDoorsAreClosed];
                
			} else {
                // The doors are still open, so we need to initiate close sequence.
                if(upperPanelDelta > 0.0f) {
                    upperPanelDelta -= (UPPER_PANEL_DELTA(upperPanelHeight) * PANEL_OPEN_SPEED_FAST);
                    lowerPanelDelta -= (LOWER_PANEL_DELTA(lowerPanelHeight) * PANEL_OPEN_SPEED_FAST);
                    if(upperPanelDelta < 0.0f) upperPanelDelta = 0.0f;
                    if(lowerPanelDelta < 0.0f) lowerPanelDelta = 0.0f;
                    
                    // Fade the music in with with the scene transition and graphics.
                    musicVolume -= FRAME_DELTA;
                    effectsVolume -= FRAME_DELTA;
                    
                    [self clampVolumeToSettings];
                    
                    if(levelLoaded) {
                        [self sceneFinishesDoorsAreOpen];
                        levelLoaded = NO;
                    }
                    
                } else {
                    doorsOpen = NO;
                }
            }
			
			break;
			
		case kSceneState_TransitionIn:
            
            // **********************************************************************************************
            // SCENE STARTS!
            // **********************************************************************************************
            
            // Adjust the music volume for the current scene.
            if(![_soundManager isMusicPlaying]) {
                doorsOpen = NO;
                levelLoaded = NO;
                
                [self sceneStartsWithDoorsClosed];
            }
            
            // Detect if this is the first time this scene has been executed.
            if(upperPanelDelta < upperPanelHeight) {
                upperPanelDelta += (UPPER_PANEL_DELTA(upperPanelHeight) * PANEL_OPEN_SPEED_FAST);
                lowerPanelDelta += (LOWER_PANEL_DELTA(lowerPanelHeight) * PANEL_OPEN_SPEED_FAST);
                
                // Fade the music in with with the scene transition and graphics.
                musicVolume += FRAME_DELTA;
                effectsVolume += FRAME_DELTA;
                
                [self clampVolumeToSettings];
                
            } else {
                doorsOpen = YES;
                levelLoaded = YES;
                
                sceneState = kSceneState_Running;
                
                [self sceneStartsDoorsAreOpen];
            }
            
			break;
			
		default:
			break;
	}
	
}

- (void)sceneStartsWithDoorsClosed {
    // Initiate the game engine for this configuration.
    [_gameManager loadDailyChallenge];

    [_soundManager setMusicVolume:0.0f];
    [_soundManager setFxVolume:0.0f];
    
    [_soundManager playMusicWithKey:DAILY_LOOP_KEY timesToRepeat:-1];
    
}

- (void)sceneStartsDoorsAreOpen {
    // Retrieve the menu configuration for this scene.
    config = [_configManager getDailyConfig];
    
    // Reset the active menu option every time the scene runs.
    [control reset];
}

- (void)sceneFinishesDoorsAreOpen {
}

- (void)sceneFinishesDoorsAreClosed {
    [_soundManager stopMusic];
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
    
    // Set our volume controls on sound system.
    [_soundManager setMusicVolume:musicVolume];
    [_soundManager setFxVolume:effectsVolume];
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

- (void)updateMenu:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    UIFadeButton *button = [control getActiveButton];
    if(button != nil) {
        
        // Do we want to navigate to the previous stage?
        if([[button ID] isEqualToString:HOME_BUTTON_KEY]) {
            [self transitionToSceneWithKey:MENU_SCENE_KEY];
        } else {
            [self transitionToSceneWithKey:GAME_SCENE_KEY];
        }
    }
}

- (void)transitionToSceneWithKey:(NSString*)key {
    nextSceneKey = key;
    [self setSceneState:kSceneState_TransitionOut];
}

- (void)renderNavigationButtons {
    // Render the scene navigations buttons
    for(int i=0; i < [config buttons].count; i++) {
        
        float alpha = 1.0f;
        
        UIFadeButton *button = [[config buttons] objectAtIndex:i];
        UIFadeButton *active = [control getActiveButton];
        if(active != nil) {
            if([active ID] == [button ID]) {
                alpha = 0.7f;
            }
        }
        
        Image *image = (Image*)[_imageManager getImageWithKey:[button ID]];
        [image setAlpha:alpha];
        
        [image renderAtPoint:[button position] centerOfImage:YES];
    }
}

- (void)render {
    [background renderAtPoint:CGPointMake(_centreX, _centreY) centerOfImage:YES];
    [emitter renderParticles];
    
    // Render the menu title text which is specific to the configuration.
    [sceneTitle renderAtPoint:[config titlePosition] centerOfImage:YES];
    
    // Render the menu icons for this particular stage
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:0] position] text:[[_gameManager getLevel] title]];
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:1] position] text:[[_gameManager level] music]];
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:2] position] text:[UIHelper formatTimeFromSeconds:(int)[[_gameManager getLevel] duration]]];
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:3] position] text:[NSString stringWithFormat:@"%.2f%%", [[_gameManager getLevel] target]]];
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:4] position] text:[NSString stringWithFormat:@"%d", [[_gameManager getLevel] lives]]];
    
    // Render the menu navigation icons for this scene.
    [self renderNavigationButtons];
    
    // Display the scene doors, which should be re-factored to the abstract layer.
    [[_imageManager getImageWithName:UPPER_DOOR_KEY] renderAtPoint:CGPointMake(0, _centreY + upperPanelDelta) centerOfImage:NO];
    [[_imageManager getImageWithName:LOWER_DOOR_KEY] renderAtPoint:CGPointMake(0, 0.0f - lowerPanelDelta) centerOfImage:NO];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(levelLoaded) {
        [control touchesBegan:touches withEvent:event view:view];
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(levelLoaded) {
        [control touchesMoved:touches withEvent:event view:view];
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(levelLoaded) {
        [control touchesEnded:touches withEvent:event view:view];
        
        [self updateMenu:touches withEvent:event view:view];
    }
    [control reset];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(levelLoaded) {
        [control touchesCancelled:touches withEvent:event view:view];
    }
    [control reset];
}

- (void)dealloc {
	[super dealloc];
    [font release];
    [details release];
    [buttons release];
    [control release];
    [sceneTitle release];
	[background release];
    [emitter release];
}

@end
