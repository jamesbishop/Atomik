//
//  RulesScene.m
//  Atomik
//
//  Created by James on 4/16/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "RulesScene.h"

@interface RulesScene (Private)
// Implement private methods here.
@end

@implementation RulesScene

@synthesize rules;

- (id)init {
	if(self = [super init]) {
        
#ifdef DEBUG
        //NSLog(@"- Loading Rules Scene ...");
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
		
        touchScreen = (Image*)[[Image alloc] initWithImage:@"Touch_Screen" width:_width height:64];

        rules = [[NSMutableArray alloc] init];
        
        for(int i=1; i <= 6; i++) {
            NSString *name = [NSString stringWithFormat:@"How2Play_%d", i];
            Image *screen = [[Image alloc] initWithImage:name width:_width height:_height];
            [rules addObject:screen];
            [screen release];
        }

        [_soundManager loadMusicWithKey:RULES_LOOP_KEY musicFile:@"Menu_Scene.mp3"];
        [_soundManager setMusicVolume:0.0f];
        
        //upperPanelHeight = (_centreY - UPPER_PANEL_LIP_HEIGHT);
        //lowerPanelHeight = (_centreY - LOWER_PANEL_LIP_HEIGHT);
        upperPanelHeight = _centreY;
        lowerPanelHeight = _centreY;
        
        upperPanelDelta = 0.0f;
        lowerPanelDelta = 0.0f;
        
        musicVolume = 0.0f;
        effectsVolume = 0.0f;
        
        doorsOpen = NO;
        menuActive = NO;
        
        ruleIndex = 0;
        showIndex = 0;
        
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
            
            // Adjust the alpha of all the components in the scene.
            [_sceneManager setGlobalAlpha:sceneAlpha];
            
            if(![_soundManager isMusicPlaying]) {
                [_soundManager playMusicWithKey:CREDITS_LOOP_KEY timesToRepeat:-1];
                
                doorsOpen = NO;
                menuActive = NO;
                
                [self sceneStartsWithDoorsClosed];
            }
            
            // Detect if this is the first time this scene has been executed.
            if(upperPanelDelta < upperPanelHeight) {
                upperPanelDelta += (UPPER_PANEL_DELTA(upperPanelHeight) * PANEL_OPEN_SPEED_FAST);
                lowerPanelDelta += (LOWER_PANEL_DELTA(lowerPanelHeight) * PANEL_OPEN_SPEED_FAST);
                if(upperPanelDelta < 0.0f) upperPanelDelta = 0.0f;
                if(lowerPanelDelta < 0.0f) lowerPanelDelta = 0.0f;
                
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
    
    showIndex = ruleIndex;
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

- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView *)view {
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event view:(UIView*)view {
    if(doorsOpen) {
        [_soundManager playSoundWithKey:MENU_SELECT_KEY];
        
        ruleIndex++;
        if(ruleIndex == 6) {
            ruleIndex = 0;
            
            [self transitionToSceneWithKey:MENU_SCENE_KEY];
        } else {
            [self transitionToSceneWithKey:RULES_SCENE_KEY];
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
    // Display the back image, which is the company logo in the scene.
	[[rules objectAtIndex:showIndex] renderAtPoint:CGPointMake(_centreX, _centreY) centerOfImage:YES];
    
    [touchScreen renderAtPoint:CGPointMake(_centreX, 85.0f) centerOfImage:YES];

    // Display the scene doors, which should be re-factored to the abstract layer.
    [[_imageManager getImageWithName:UPPER_DOOR_KEY] renderAtPoint:CGPointMake(0, _centreY + upperPanelDelta) centerOfImage:NO];
    [[_imageManager getImageWithName:LOWER_DOOR_KEY] renderAtPoint:CGPointMake(0, 0.0f - lowerPanelDelta) centerOfImage:NO];
}

- (void)dealloc {
	[super dealloc];
	[rules release];
    [touchScreen release];
}

@end
