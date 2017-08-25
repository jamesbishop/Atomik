//
//  StageScene.m
//
//  Created by James Bishop on 4/14/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "StageScene.h"

@interface StageScene (Private)
- (void)updateMenu:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (void)clampVolumeToSettings;
- (void)updateStageIcons;
- (void)renderStageIcons;
- (void)renderNavigationButtons;
@end

@implementation StageScene

- (id)init {
	if(self = [super init]) {
        
#ifdef DEBUG
        //NSLog(@"- Loading Stage Scene ...");
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
        
        [_configManager loadStageConfigWithWidth:_width andHeight:_height];
        config = [_configManager getStageConfig];
        
        background = [[Image alloc] initWithImage:[config sceneImage] width:_width height:_height];
		
        sceneTitle = (Image*)[[Image alloc] initWithImage:[config sceneTitle] width:_width height:64];
        
        font = [[Font alloc] initWithFontImageNamed:@"ObelixPro_Outline_22" controlFile:@"ObelixPro_Outline_22" scale:1.0f filter:GL_LINEAR];

        // Now we need to load the menu items into the image buffers
        icons = [[NSMutableArray alloc] init];
        for(int i=0; i <= 5; i++) {
            Image *icon = [[Image alloc] initWithImage:[NSString stringWithFormat:@"Icon_State_%d", i] width:80 height:80];
            [icons addObject:icon];
            [icon release];
        }
        
        buttons = [[NSMutableArray alloc] init];
        
        // Now we need to load the menu buttons into the image buffers
        for(int i=0; i < [config buttons].count; i++) {
            UIFadeButton *button = (UIFadeButton*)[[config buttons] objectAtIndex:i];
            
            int width = [button bounds].size.width;
            int height = [button bounds].size.height;
            
            Image *image = (Image*)[[Image alloc] initWithImage:[button ID] width:width height:height];
            [_imageManager addImage:image andKey:[button ID]];
            [image release];
        }

        // Add the music files to our audio sub-system.
        [_soundManager loadMusicWithKey:STAGE_LOOP_KEY musicFile:[config sceneMusic]];
        
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
        
        activeMenuOption = -1;
        
        currentStage = 1;
        currentLevel = 0;
        displayStage = currentStage;
        
        control = [[StageControl alloc] init];
        
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
                                                        maxParticles:300
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
                    
                    displayStage = currentStage;
                    
                    [self updateStageIcons];
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

- (void)sceneStartsWithDoorsClosed {
    [_soundManager setMusicVolume:0.0f];
    [_soundManager setFxVolume:0.0f];
    
    [_soundManager playMusicWithKey:STAGE_LOOP_KEY timesToRepeat:-1];
    
}

- (void)sceneStartsDoorsAreOpen {
    // Retrieve the menu configuration for this scene.
    config = [_configManager getStageConfig];
    
    // Reset the active menu option every time the scene runs.
    [control reset];
    
    currentLevel = 0;
    
    [self updateStageIcons];
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

- (void)updateStageIcons {
    for(int level=1; level <= [config icons].count; level++) {
        UIFadeButton *button = (UIFadeButton*)[[config icons] objectAtIndex:(level-1)];
        [button setState:[_progressManager getStateForStage:currentStage withLevel:level]];
    }
}

- (void)updateMenu:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(currentLevel > 0) {
        [_gameManager setup:currentStage withLevel:currentLevel];
        [self transitionToSceneWithKey:GAME_SCENE_KEY];
        
    } else {
        UIFadeButton *button = [control getActiveButton];
        if(button != nil) {
            
            // Do we want to navigate to the previous stage?
            if([[button ID] isEqualToString:BACK_BUTTON_KEY]) {
#ifdef LITE_VERSION
                [self transitionToSceneWithKey:PURCHASE_SCENE_KEY];
#else
                currentStage--;
                if(currentStage < 1) {
                    currentStage = STAGES_IN_GAME;
                }
                [self transitionToSceneWithKey:STAGE_SCENE_KEY];
#endif
            }
            
            // Do we want to navigate back to the main menu?
            if([[button ID] isEqualToString:HOME_BUTTON_KEY]) {
                [self transitionToSceneWithKey:MENU_SCENE_KEY];
            }
            
            // Do we want to navigate to the next stage?
            if([[button ID] isEqualToString:NEXT_BUTTON_KEY]) {
#ifdef LITE_VERSION
                [self transitionToSceneWithKey:PURCHASE_SCENE_KEY];
#else
                currentStage++;
                if(currentStage > STAGES_IN_GAME) {
                    currentStage = 1;
                }
                [self transitionToSceneWithKey:STAGE_SCENE_KEY];
#endif
            }
        }
    }
}

- (void)transitionToSceneWithKey:(NSString*)key {
    nextSceneKey = key;
    [self setSceneState:kSceneState_TransitionOut];
}

- (void)renderStageIcons {
    // Render the active and inactive menu items for the user selection
    for(int index=1; index <= [config icons].count; index++) {
        
        float alpha = 1.0f;
        
        UIFadeButton *button = (UIFadeButton*)[[config icons] objectAtIndex:(index-1)];
        UIFadeButton *active = [control getActiveButton];
        if(active != nil) {
            if([[active ID] integerValue] == [[button ID] integerValue]) {
                currentLevel = (int)[[button ID] integerValue];
                alpha = 0.7f;
            }
        } else {
            currentLevel = 0;
        }
        
        int x = [button position].x;
        int y = [button position].y;
        int state = [button state];
        
        Image *icon = (Image*)[icons objectAtIndex:state];
        [icon setAlpha:alpha];
        
        [icon renderAtPoint:CGPointMake(x, y) centerOfImage:YES];
        
        if(state > -1) {
            int playLevel = ((displayStage - 1) * LEVELS_PER_STAGE) + index;
            int textWidth = [font getWidthForString:[NSString stringWithFormat:@"%d", playLevel]];
            int positionX = (x - (textWidth / 2));
            int positionY = (y + [config iconFontY]);
            
            [font drawStringAt:CGPointMake(positionX, positionY) text:[NSString stringWithFormat:@"%d", playLevel]];
        }
    }
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
    [self renderStageIcons];
    
    // Render the menu navigation icons for this scene.
    [self renderNavigationButtons];
    
    // Display the scene doors, which should be re-factored to the abstract layer.
    [[_imageManager getImageWithName:UPPER_DOOR_KEY] renderAtPoint:CGPointMake(0, _centreY + upperPanelDelta) centerOfImage:NO];
    [[_imageManager getImageWithName:LOWER_DOOR_KEY] renderAtPoint:CGPointMake(0, 0.0f - lowerPanelDelta) centerOfImage:NO];
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(menuActive) {
        [control touchesBegan:touches withEvent:event view:view];
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(menuActive) {
        [control touchesMoved:touches withEvent:event view:view];
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(menuActive) {
        [control touchesEnded:touches withEvent:event view:view];
    
        [self updateMenu:touches withEvent:event view:view];
    }
    [control reset];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(menuActive) {
        [control touchesCancelled:touches withEvent:event view:view];
    }
    [control reset];
}

- (void)dealloc {
	[super dealloc];
    [font release];
    [icons release];
    [buttons release];
    [control release];
    [sceneTitle release];
	[background release];
    [emitter release];
}

@end
