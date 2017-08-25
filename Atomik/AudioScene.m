//
//  AudioScene.m
//  Atomik
//
//  Created by James on 2/2/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "AudioScene.h"

@interface AudioScene (Private)
- (void)initialiseControls;
- (void)resetVolumes;
- (void)adjustVolumes;
- (void)clampVolumeToSettings;

- (void)updateVolumeSliders:(float)delta;
- (void)updateButtons:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view;
- (NSString*)percentage:(float)volume;
- (void)centreText:(NSString*)text atLocation:(CGPoint)location;
- (void)renderNavigationButtons;
- (void)saveAudioSettings;
@end

@implementation AudioScene

- (id)init {
	if(self = [super init]) {
        
#ifdef DEBUG
        //NSLog(@"- Loading Audio Scene ...");
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

        [_configManager loadAudioConfigWithWidth:_width andHeight:_height];
        config = [_configManager getAudioConfig];
        
		background = [(Image*)[Image alloc] initWithImage:[config sceneImage] width:_width height:_height];

        sceneTitle = (Image*)[[Image alloc] initWithImage:[config sceneTitle] width:_width height:64];
        
        font = [[Font alloc] initWithFontImageNamed:@"ObelixPro_Shadow_14" controlFile:@"ObelixPro_Shadow_14" scale:1.0f filter:GL_LINEAR];
        
        // Now we need to load the menu buttons into the image buffers
        for(int i=0; i < [config buttons].count; i++) {
            UIFadeButton *button = (UIFadeButton*)[[config buttons] objectAtIndex:i];
            
            int width = [button bounds].size.width;
            int height = [button bounds].size.height;
            
            Image *image = (Image*)[[Image alloc] initWithImage:[button ID] width:width height:height];
            [_imageManager addImage:image andKey:[button ID]];
            [image release];
            
            [button reset];
        }
        
        [_soundManager loadMusicWithKey:AUDIO_LOOP_KEY musicFile:[config sceneMusic]];
        [_soundManager setMusicVolume:0.0f];
        
        upperPanelHeight = (_centreY - UPPER_PANEL_LIP_HEIGHT);
        lowerPanelHeight = (_centreY - LOWER_PANEL_LIP_HEIGHT);
        
        upperPanelDelta = 0.0f;
        lowerPanelDelta = 0.0f;
        
        musicVolume = 0.0f;
        effectsVolume = 0.0f;
        
        [self initialiseControls];
        
        doorsOpen = NO;
        menuActive = NO;
        
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

- (void)initialiseControls {
    ProgressData *progress = [_progressManager getProgressData];
    _displayMusicVolume = [progress musicVolume];
    _displayEffectsVolume = [progress effectsVolume];
    
    [(UISliderControl*)[[config sliders] objectAtIndex:0] setValue:_displayMusicVolume];
    [(UISliderControl*)[[config sliders] objectAtIndex:1] setValue:_displayEffectsVolume];
    
    control = [[AudioControl alloc] init];
    [control setSliders:[config sliders]];
    [control setButtons:[config buttons]];

    [self adjustVolumes];
}

- (void)resetVolumes {
    // We no longer need yo reset these controls.
    
}

- (void)adjustVolumes {
    [_soundManager setMusicVolume:_displayMusicVolume];
    [_soundManager setFxVolume:_displayEffectsVolume];
}

- (void)updateVolumeSliders:(float)delta {
    UISliderControl *music = (UISliderControl*)[[config sliders] objectAtIndex:0];
    [music update:delta];
    _displayMusicVolume = [music value];

    UISliderControl *effects = (UISliderControl*)[[config sliders] objectAtIndex:1];
    [effects update:delta];
    _displayEffectsVolume = [effects value];

    [self adjustVolumes];
}

- (void)update:(GLfloat)delta {
	
    [emitter update:delta];

	switch (sceneState) {
		case kSceneState_Running:
            
            [self updateVolumeSliders:delta];
            
			break;
			
		case kSceneState_TransitionOut:
            
            // Adjust the alpha of all the components in the scene.
            [_sceneManager setGlobalAlpha:sceneAlpha];
			
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
                    effectsVolume -= FRAME_DELTA;
                    
                    [self clampVolumeToSettings];
                    
                    menuActive = NO;

                } else {
                    doorsOpen = NO;
                }
            }
			
			break;
			
		case kSceneState_TransitionIn:
            
            // Adjust the alpha of all the components in the scene.
            [_sceneManager setGlobalAlpha:sceneAlpha];
            
            if(![_soundManager isMusicPlaying]) {
                [_soundManager playMusicWithKey:AUDIO_LOOP_KEY timesToRepeat:-1];
            }
            
            // Detect if this is the first time this scene has been executed.
            if(upperPanelDelta < upperPanelHeight) {
                upperPanelDelta += (UPPER_PANEL_DELTA(upperPanelHeight) * PANEL_OPEN_SPEED_FAST);
                lowerPanelDelta += (LOWER_PANEL_DELTA(lowerPanelHeight) * PANEL_OPEN_SPEED_FAST);
                if(upperPanelDelta < 0.0f) upperPanelDelta = 0.0f;
                if(lowerPanelDelta < 0.0f) lowerPanelDelta = 0.0f;
                
                musicVolume += FRAME_DELTA;
                effectsVolume += FRAME_DELTA;
                
                [self clampVolumeToSettings];
                
            } else {
                doorsOpen = YES;
                menuActive = YES;
                
                sceneState = kSceneState_Running;
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

- (void)saveAudioSettings {
    // We need to assign our new values to settings.
    ProgressData *progress = [_progressManager getProgressData];
    [progress setMusicVolume:_displayMusicVolume];
    [progress setEffectsVolume:_displayEffectsVolume];
    
    // Save the progress data to the data store.
    [_progressManager saveProgressData:progress];
    
    // We need to reload our progress data now.
    [_progressManager loadProgressData];
}

- (void)updateButtons:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    UIFadeButton *button = [control getActiveButton];
    if(button != nil) {
        // Do we want to navigate to the previous stage?
        if([[button ID] isEqualToString:HOME_BUTTON_KEY]) {
            [self saveAudioSettings];
            [self transitionToSceneWithKey:MENU_SCENE_KEY];
        }
        
        [_soundManager playSoundWithKey:MENU_SELECT_KEY];
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
    
        [self updateButtons:touches withEvent:event view:view];
    }
    [control reset];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(menuActive) {
        [control touchesCancelled:touches withEvent:event view:view];
    }
    [control reset];
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
    // Display the back image, which is the company logo in the scene.
	[background renderAtPoint:CGPointMake(_centreX, _centreY) centerOfImage:YES];
    [emitter renderParticles];
    
    // Display the menu title for this particular scene from config.
    [sceneTitle renderAtPoint:CGPointMake([config titlePosition].x, [config titlePosition].y) centerOfImage:YES];

    [self renderNavigationButtons];
    
    // Display our active audio control sliders from the config.
    for(int i=0; i < [config sliders].count; i++) {
        UISliderControl *slider = (UISliderControl*)[[config sliders] objectAtIndex:i];

        NSString *title = (i == 0) ? @"Music" : @"Effects";
        
        // Display our audio controls and text labels for this scene.
        //CGPoint location = CGPointMake(slider.position.x, 185.0f);
        NSString *percentage = [UIHelper formatPercentageFromDecimal:slider.value];
        if(slider.value == 0.0) {
            percentage = @"MUTE";
        } else if(slider.value == 1.0) {
            percentage = @"MAXIMUM";
        }
        
        //[UIHelper centreText:title withFont:font atLocation:CGPointMake(slider.position.x, 455.0f)];
        [UIHelper centreText:title withFont:font atLocation:[slider titleText]];
        [UIHelper centreText:percentage withFont:font atLocation:[slider volumeText]];

        [slider render];
    }
    
    // Display the scene doors, which should be re-factored to the abstract layer.
    [[_imageManager getImageWithName:UPPER_DOOR_KEY] renderAtPoint:CGPointMake(0, _centreY + upperPanelDelta) centerOfImage:NO];
    [[_imageManager getImageWithName:LOWER_DOOR_KEY] renderAtPoint:CGPointMake(0, 0.0f - lowerPanelDelta) centerOfImage:NO];
}

- (void)dealloc {
	[super dealloc];
    [sceneTitle release];
    [font release];
	[background release];
    [emitter release];
}

@end
