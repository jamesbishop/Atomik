//
//  MenuScene.m
//
//  Created by James Bishop on 4/14/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "MenuScene.h"

@interface MenuScene (Private)
- (void)updateMenu:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)clampVolumeToSettings;
@end

@implementation MenuScene

- (id)init {
	if(self = [super init]) {
        
#ifdef DEBUG
        //NSLog(@"- Loading Menu Scene ...");
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

        [_configManager loadMenuConfigWithWidth:_width andHeight:_height];
        config = [_configManager getMenuConfig];
        
        background = [[Image alloc] initWithImage:[config sceneImage] width:_width height:_height];
		
        menuTitle = [[Image alloc] initWithImage:[config sceneTitle] width:320 height:64];
        
        // Now we need to load the menu items into the image buffers
        inactive = [[NSMutableArray alloc] init];
        active = [[NSMutableArray alloc] init];
        
        // Build the image menu button model from the configuration.
        for(int i=0; i < [config buttons].count; i++) {
            UIFadeButton *button = (UIFadeButton*)[[config buttons] objectAtIndex:i];
            
            int width = [button bounds].size.width;
            int height = [button bounds].size.height;
            
            Image *temp = [[Image alloc] initWithImage:[NSString stringWithFormat:@"%@_Off", [button ID]] width:width height:height];
            [inactive addObject:temp];
            [temp release];

            temp = [[Image alloc] initWithImage:[NSString stringWithFormat:@"%@_On", [button ID]] width:width height:height];
            [active addObject:temp];
            [temp release];
        }

        // Add the music files to our audio sub-system.
        [_soundManager loadMusicWithKey:MENU_LOOP_KEY musicFile:[config sceneMusic]];
        
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
        menuActive = NO;
        
        control = [[MenuControl alloc] init];

        // Angles: 0=Right, 90=Down, 180=Left, 270=Up
        emitter = [[Emitter alloc] initParticleEmitterWithImageNamed:PARTICLE_EMITTER_SPOTLITE
                                                            position:Vector2fMake(_centreX, 290.0f)
                                              sourcePositionVariance:Vector2fMake(160, 160)
                                                               speed:1.0f
                                                       speedVariance:2.0f
                                                    particleLifeSpan:1.0f	
                                            particleLifespanVariance:2.0f
                                                               angle:0.5f
                                                       angleVariance:360.0f
                                                             gravity:Vector2fMake(0.0f, -0.0f)
                                                          startColor:Color4fMake(1.00f, 1.00f, 1.00f, 1.00f)
                                                  startColorVariance:Color4fMake(0.00f, 0.00f, 0.00f, 0.00f)
                                                         finishColor:Color4fMake(0.25f, 1.00f, 1.00f, 1.00f)
                                                 finishColorVariance:Color4fMake(0.10f, 0.10f, 0.10f, 0.00f)
                                                        maxParticles:350
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
                    
                    if(menuActive) {
                        [self sceneFinishesDoorsAreOpen];
                        menuActive = NO;
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
                
                // Reset the active menu option every time the scene runs.
                for(int i=0; i < [config buttons].count; i++) {
                    [(UIFadeButton*)[[config buttons] objectAtIndex:i] setState:BUTTON_INACTIVE];
                }

                doorsOpen = NO;
                menuActive = NO;
                
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
                menuActive = YES;
                
                sceneState = kSceneState_Running;
                
                [self sceneStartsDoorsAreOpen];
            }

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

    // Set our volume controls on sound system.
    [_soundManager setMusicVolume:musicVolume];
    [_soundManager setFxVolume:effectsVolume];
}

- (void)sceneStartsWithDoorsClosed {
    [_soundManager setMusicVolume:0.0f];
    [_soundManager playMusicWithKey:MENU_LOOP_KEY timesToRepeat:-1];

}

- (void)sceneStartsDoorsAreOpen {
    ProgressData *progress = [_progressManager getProgressData];
    [_soundManager setMusicVolume:[progress musicVolume]];
    [_soundManager setFxVolume:[progress effectsVolume]];
}
 
- (void)sceneFinishesDoorsAreOpen {
    
}
    
- (void)sceneFinishesDoorsAreClosed {
    [_soundManager stopMusic];
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
    // Do not update the state of the menu if we've turned it off.
    if(!menuActive) {
        return;
    }
    
    // Get the details of all the touches for this view.
    UITouch *touch = [[event touchesForView:view] anyObject];
    CGPoint location = [touch locationInView:view];
    
    // Touches are not handled in the same way and rendering.
    location.y = (_height - location.y);

    // Update the state of each of the buttons in the config.
    for(int i=0; i < [config buttons].count; i++) {
        UIFadeButton *button = (UIFadeButton*)[[config buttons] objectAtIndex:i];
        
        float width = [button bounds].size.width;
        float height = [button bounds].size.height;
        float left = [button position].x - (width / 2.0f);
        float bottom = [button position].y - (height / 2.0f);
        
        if(CGRectContainsPoint(CGRectMake(left, bottom, width, height), location)) {
            [button setState:BUTTON_ACTIVE];
        } else {
            [button setState:BUTTON_INACTIVE];
        }
    }
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    [self updateMenu:touches withEvent:event view:view];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    [self updateMenu:touches withEvent:event view:view];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    [self updateMenu:touches withEvent:event view:view];
    
    if(menuActive) {
        int activeMenuOption = -1;
        for(int i=0; i < [config buttons].count; i++) {
            UIFadeButton *button = (UIFadeButton*)[[config buttons] objectAtIndex:i];
            if([button state] == 1) {
                activeMenuOption = i;
                break;
            }
        }
        
        if(activeMenuOption >= 0) {
            
            // Play sound effect to signal a scene change
            [_soundManager playSoundWithKey:MENU_SELECT_KEY];
            
            // Which menu option has the user selected?
            if(activeMenuOption == 0) {
                [self transitionToSceneWithKey:STAGE_SCENE_KEY];
            } else if(activeMenuOption == 1) {
                // Audio FX
                [self transitionToSceneWithKey:AUDIO_SCENE_KEY];
            } else if(activeMenuOption == 2) {
                // How To Play
                [self transitionToSceneWithKey:RULES_SCENE_KEY];
            } else if(activeMenuOption == 3) {
                // Challenge
                [self transitionToSceneWithKey:DAILY_SCENE_KEY];
            } else {
                [self transitionToSceneWithKey:CREDITS_SCENE_KEY];
            }
        }
    }
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // Reset the menu options all the an inctive state.
    [control reset];
}

- (void)transitionToSceneWithKey:(NSString*)key {
    nextSceneKey = key;
    [self setSceneState:kSceneState_TransitionOut];
}

- (void)render {
    [background renderAtPoint:CGPointMake(_centreX, _centreY) centerOfImage:YES];
    [emitter renderParticles];
    
    // Render the menu title at the top of the screen from the config.
    [menuTitle renderAtPoint:CGPointMake(_centreX, [config iconTitleY]) centerOfImage:YES];
    
    // Render the active and inactive menu items for the user selection.
    for(int i=0; i < [config buttons].count; i++) {
        UIFadeButton *button = (UIFadeButton*)[[config buttons] objectAtIndex:i];
        if(button.state == BUTTON_INACTIVE) {
            [(Image*)[inactive objectAtIndex:i] renderAtPoint:[button position] centerOfImage:YES];
        } else {
            [(Image*)[active objectAtIndex:i] renderAtPoint:[button position] centerOfImage:YES];
        }
    }
    
    // TODO: Display the prompts of what the menu options actually do if selected.
    
    // Display the scene doors, which should be re-factored to the abstract layer.
    [[_imageManager getImageWithName:UPPER_DOOR_KEY] renderAtPoint:CGPointMake(0, _centreY + upperPanelDelta) centerOfImage:NO];
    [[_imageManager getImageWithName:LOWER_DOOR_KEY] renderAtPoint:CGPointMake(0, 0.0f - lowerPanelDelta) centerOfImage:NO];
}


- (void)dealloc {
	[super dealloc];
    [inactive release];
    [active release];
    [emitter release];
    [control release];
    [menuTitle release];
	[background release];	
}

@end
