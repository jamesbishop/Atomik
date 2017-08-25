//
//  GameScene.m
//
//  Created by James Bishop on 4/14/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "GameScene.h"

@interface GameScene (Private)
- (void)updateState:(float)delta;

- (void)clampVolumeToSettings;

- (void)renderPowerUps;
- (void)renderBlastDoors;

@end

@implementation GameScene

- (id)init {
	if(self = [super init]) {
        
#ifdef DEBUG
        //NSLog(@"- Loading Game Scene ...");
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
        sceneAlpha = 0.0f;
		
        [_sceneManager setGlobalAlpha:sceneAlpha];
        
        font = [[Font alloc] initWithFontImageNamed:@"ObelixPro_Shadow_14" controlFile:@"ObelixPro_Shadow_14" scale:1.0f filter:GL_LINEAR];
        
        control = [[GameControl alloc] init];
        
        upperPanelHeight = _centreY;    // 240 or 284
        lowerPanelHeight = _centreY;    // 240 or 284
        
        upperPanelDelta = 0.0f;
        lowerPanelDelta = 0.0f;
        
        musicVolume = 0.0f;
        effectsVolume = 0.0f;
        
        doorsOpen = NO;
        isSceneReady = NO;
        
        _score = [[_gameManager getScore] score];
        
		nextSceneKey = nil;
		[self setSceneState:kSceneState_TransitionIn];
	}
	return self;
}

- (void)updateState:(float)delta {
    int gameScore = [[_gameManager getScore] score];
    if(_score < gameScore) {
        _score += (delta * 5000);
    }
    if(_score > gameScore) {
        _score = gameScore;
    }
}

- (void)update:(GLfloat)delta {
	
	switch (sceneState) {
		case kSceneState_Running:

            [_gameManager update:delta];
            
            [self updateState:delta];
            
            // Play the music associated with this level.
            if(![_soundManager isMusicPlaying]) {
                [_soundManager playMusicWithKey:GAME_LOOP_KEY timesToRepeat:-1];
            }
            
            // Check timer has expired, so we need to go to our scoreboard.
            if([_gameManager isGameOver]) {
                [self transitionToSceneWithKey:SCORE_SCENE_KEY];
            }
            
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

                    musicVolume -= FRAME_DELTA;
                    effectsVolume -= FRAME_DELTA;
                    
                    [self clampVolumeToSettings];
                    
                } else {
                    doorsOpen = NO;
                }
            }
			
			break;
			
		case kSceneState_TransitionIn:

            // Adjust the alpha of all the components in the scene.
            [_sceneManager setGlobalAlpha:sceneAlpha];

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

- (void)setSceneState:(uint)state {
	sceneState = state;
	if(sceneState == kSceneState_TransitionOut) {
        sceneAlpha = 1.0f;
	}
	if(sceneState == kSceneState_TransitionIn) {
        sceneAlpha = 1.0f;
	}
}

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // ==============================================================
    // Version v1.0.1: Only allow movement if game is still running.
    // ==============================================================
    if(![_gameManager isGameOver]) {
        [control touchesBegan:touches withEvent:event view:view];
    }
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // ==============================================================
    // Version v1.0.1: Only allow movement if game is still running.
    // ==============================================================
    if(![_gameManager isGameOver]) {
        [control touchesMoved:touches withEvent:event view:view];
    }
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // ==============================================================
    // Version v1.0.1: Only allow movement if game is still running.
    // ==============================================================
    if(![_gameManager isGameOver]) {
        [control touchesEnded:touches withEvent:event view:view];
    }
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    // ==============================================================
    // Version v1.0.1: Only allow movement if game is still running.
    // ==============================================================
    if(![_gameManager isGameOver]) {
        [control touchesCancelled:touches withEvent:event view:view];
    }
}

- (void)transitionToSceneWithKey:(NSString*)key {
    nextSceneKey = key;
    [self setSceneState:kSceneState_TransitionOut];
}


- (void)renderPowerUps {
    if([_gameManager isActivePowerUp]) {
        const int active = [_gameManager activePowerUp];
        
        if(active > 0) {
            Image *powerup = (Image*)[[_gameManager powerups] objectAtIndex:(active-1)];
            [powerup renderAtPoint:CGPointMake(175.0f, 24.0f) centerOfImage:NO];
        }
    }
}

- (void)renderBlastDoors {
    if(sceneState != kSceneState_Running) {
        [[_imageManager getImageWithKey:UPPER_DOOR_KEY] renderAtPoint:CGPointMake(0, _centreY + upperPanelDelta) centerOfImage:NO];
        [[_imageManager getImageWithKey:LOWER_DOOR_KEY] renderAtPoint:CGPointMake(0, 0.0f - lowerPanelDelta) centerOfImage:NO];
    }
}

- (void)render {

    // Draw the background image, which may change later on from level to level.
	[[_gameManager background] renderAtPoint:CGPointMake(0.0f, 0.0f) centerOfImage:NO];

    // Draw the sinkholes first, as they are "placed on" the background.
    [[[_gameManager level] sinkholes] makeObjectsPerformSelector:(@selector(render))];
    
    for(int i=0; i < [_gameManager molecules].count; i++) {
        DraggableMolecule *shape = (DraggableMolecule*)[[_gameManager molecules] objectAtIndex:i];
        [shape render];
    }
    
    for(int i=0; i < [_gameManager level].spawnpods.count; i++) {
        SpawnPod *entity = [[[_gameManager level] spawnpods] objectAtIndex:i];
        if([entity depth] == 1) {
            [entity render];
        }
    }

    [[_gameManager pipeline] renderAtPoint:CGPointMake(0.0f, 0.0f) centerOfImage:NO];

    for(int i=0; i < [_gameManager level].spawnpods.count; i++) {
        SteamPod *entity = [[[_gameManager level] spawnpods] objectAtIndex:i];
        if([entity depth] == 2) {
            [entity render];
        }
    }

    [[_gameManager scoreboard] renderAtPoint:CGPointMake(0.0f, 0.0f) centerOfImage:NO];
    
    PlayerScore *score = (PlayerScore*)[_gameManager getScore];
    
    [font drawStringAt:CGPointMake(75.0f, 52.0f) text:[UIHelper formatNumberWithCommas:_score]];
    [font drawStringAt:CGPointMake(75.0f, 26.0f) text:[UIHelper formatLivesRemaining:score.livesRemaining withAllowed:score.livesAllowed]];
    [font drawStringAt:CGPointMake(235.0f, 26.0f) text:[UIHelper formatTimeFromSeconds:[_gameManager timer]]];
    
#ifdef DEBUG
    if(DISPLAY_FRAME_RATE) {
        NSString *fpsText = [NSString stringWithFormat:@"FPS: %.f", [_sceneManager framesPerSecond]];
        [font drawStringAt:CGPointMake((_width - 80.0f), (_height - 30)) text:fpsText];
    }
#endif

    // We need to render the hints that are added to our game scene.
    for(int i=0; i < [[_gameManager hints] count]; i++) {
        Hint *hint = (Hint*)[[_gameManager hints] objectAtIndex:i];
        float x = [hint position].x;
        float y = [hint position].y;
        x -= [font getWidthForString:[hint text]] / 2.0f;
        [font drawStringAt:CGPointMake(x, y) text:[hint text]];
    }
    
    // We also need to render any power ups and notifications.
    [self renderPowerUps];
    
    // We don't need this fix here that only attempts to render the panel
    // doors if they are in motion or in need of a rendering context. But
    // it removes an additional render call to handle the panel doors.
    [self renderBlastDoors];
}

- (void)dealloc {
	[super dealloc];
    [control release];
    [font release];
}

@end
