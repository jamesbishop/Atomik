//
//  ScoreScene.m
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import "ScoreScene.h"

@interface ScoreScene (Private)
- (void)clampVolumeToSettings;
@end

@implementation ScoreScene

- (id)init {
	if(self = [super init]) {
        
#ifdef DEBUG
        //NSLog(@"- Loading Score Scene ...");
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
		
        [_configManager loadScoreConfigWithWidth:_width andHeight:_height];
        config = [_configManager getScoreConfig];
        
		background = (Image*)[[Image alloc] initWithImage:[config sceneImage] width:_width height:_height];
        
        sceneTitle = (Image*)[[Image alloc] initWithImage:[config sceneTitle] width:_width height:64];
        touchScreen = (Image*)[[Image alloc] initWithImage:@"Touch_Screen" width:_width height:64];
		
        // Load the level icons for showing if we passed the level.
        levels = [[NSMutableArray alloc] init];
        for(int i=0; i <= 1; i++) {
            Image *image = (Image*)[[Image alloc] initWithImage:[NSString stringWithFormat:@"Level_%d", i] width:64 height:64];
            [levels addObject:image];
            [image release];
        }

        // Load the level icons for showing if we passed the level.
        results = [[NSMutableArray alloc] init];
        for(int i=1; i <= 5; i++) {
            Image *image = (Image*)[[Image alloc] initWithImage:[NSString stringWithFormat:@"Result_%d", i] width:128 height:32];
            [results addObject:image];
            [image release];
        }

        font = [[Font alloc] initWithFontImageNamed:@"ObelixPro_Shadow_14" controlFile:@"ObelixPro_Shadow_14" scale:1.0f filter:GL_LINEAR];

        [_soundManager loadMusicWithKey:SCORE_LOOP_KEY musicFile:@"Score_Scene.mp3"];
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

                } else {
                    doorsOpen = NO;
                }
            }
			
			break;
			
		case kSceneState_TransitionIn:
            
            // Adjust the alpha of all the components in the scene.
            [_sceneManager setGlobalAlpha:sceneAlpha];
            
            if(![_soundManager isMusicPlaying]) {
                
                // Start our music on an infinite loop as we want it continuous.
                [_soundManager playMusicWithKey:SCORE_LOOP_KEY timesToRepeat:-1];
                
                // Attempt to submit the score to the server asynchronously.
                PlayerScore *playerScore = (PlayerScore*)[_gameManager getScore];
                
                // We need to update our players progress with the latest score.
                if([_gameManager isServerGame]) {
                    
                    DailyChallenge *challenge = (DailyChallenge*)[_gameManager getChallenge];
                    
                    NSLog(@"ScoreScene: %@", [challenge description]);
                    
                    [_networkManager submitDailyToServer:playerScore forChallenge:challenge];
                    
                } else {
                    [_networkManager submitScoreToServer:playerScore];
                
                    int state = [playerScore progress];
                    int stage = [playerScore stage];
                    int level = [playerScore level];
                
                    [_progressManager updateStage:stage withLevel:level andState:state];
                }
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

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView *)view {
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(doorsOpen) {
        [_soundManager playSoundWithKey:MENU_SELECT_KEY];

        if([_gameManager isServerGame]) {
            [self transitionToSceneWithKey:MENU_SCENE_KEY];
        } else {
            [self transitionToSceneWithKey:STAGE_SCENE_KEY];
        }
    }
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)transitionToSceneWithKey:(NSString*)key {
    nextSceneKey = key;
    [self setSceneState:kSceneState_TransitionOut];

}

- (void)render {
	[background renderAtPoint:CGPointMake(0.0f, 0.0f) centerOfImage:NO];
    
    [sceneTitle renderAtPoint:[config titlePosition] centerOfImage:YES];
    
    PlayerScore *score = [_gameManager getScore];

    int currentLevel = (((score.stage - 1) * LEVELS_PER_STAGE) + score.level);
    int maximumLevel = (STAGES_IN_GAME * LEVELS_PER_STAGE);
    
    [font setColourFilterRed:1.0f green:1.0f blue:1.0f alpha:1.0f];

    NSString *statistics = [NSString stringWithFormat:@"%d / %d / %d / %d", score.success, score.failure, score.missed, score.collisions];
    
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:0] position] text:[[_gameManager level] title]];
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:1] position] text:[NSString stringWithFormat:@"%d / %d", currentLevel, maximumLevel]];
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:2] position] text:statistics];
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:3] position] text:[UIHelper formatTimeFromSeconds:(int)score.duration]];
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:4] position] text:[[_gameManager level] music]];
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:5] position] text:[UIHelper formatLivesRemaining:score.livesRemaining withAllowed:score.livesAllowed]];
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:6] position] text:[UIHelper formatNumberWithCommas:score.score]];
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:7] position] text:[NSString stringWithFormat:@"%.2f%%", score.target]];
    [font drawStringAt:[(UITextLabel*)[[config details] objectAtIndex:8] position] text:[NSString stringWithFormat:@"%.2f%%", score.percentage]];
    
    if([score percentage] >= [[_gameManager level] target]) {
        [[levels objectAtIndex:0] renderAtPoint:[(UITextLabel*)[[config details] objectAtIndex:9] position] centerOfImage:YES];
    } else {
        [[levels objectAtIndex:1] renderAtPoint:[(UITextLabel*)[[config details] objectAtIndex:9] position] centerOfImage:YES];
    }
    
    [[results objectAtIndex:(score.progress-1)] renderAtPoint:[(UITextLabel*)[[config details] objectAtIndex:10] position] centerOfImage:YES];
    
    [touchScreen renderAtPoint:[(UITextLabel*)[[config details] objectAtIndex:11] position] centerOfImage:YES];
    
    // Display the scene doors, which should be re-factored to the abstract layer.
    [[_imageManager getImageWithName:UPPER_DOOR_KEY] renderAtPoint:CGPointMake(0, _centreY + upperPanelDelta) centerOfImage:NO];
    [[_imageManager getImageWithName:LOWER_DOOR_KEY] renderAtPoint:CGPointMake(0, 0.0f - lowerPanelDelta) centerOfImage:NO];
}

- (void)dealloc {
	[super dealloc];
    [config release];
    [font release];
    [levels release];
    [results release];
    [touchScreen release];
    [sceneTitle release];
	[background release];
}

@end
