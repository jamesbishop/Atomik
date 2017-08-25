//
//  SceneManager.m
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import "Common.h"
#import "SynthesizeSingleton.h"
#import "AbstractScene.h"
#import "SceneManager.h"

@implementation SceneManager

SYNTHESIZE_SINGLETON_FOR_CLASS(SceneManager);

@synthesize currentlyBoundTexture;
@synthesize currentGameState;
@synthesize currentScene;
@synthesize globalAlpha;
@synthesize framesPerSecond;
@synthesize graphicsScale;

#pragma mark Singleton Methods

- (id)init {
    if (self = [super init]) {
		// Initialize the arrays to be used within the state manager
		_scenes = [[NSMutableDictionary alloc] init];
        
		currentScene = nil;
		globalAlpha = 1.0f;
    }
    return self;
}

- (void)addSceneWithKey:(NSString*)aSceneKey scene:(AbstractScene*)aScene {
	[_scenes setObject:aScene forKey:aSceneKey];
}

- (BOOL)setCurrentSceneToSceneWithKey:(NSString*)aSceneKey {
	if(![_scenes objectForKey:aSceneKey]) {
        return NO;
    }
	
    currentScene = [_scenes objectForKey:aSceneKey];
	[currentScene setSceneAlpha:0.0f];
	[currentScene setSceneState:kSceneState_TransitionIn];
	
    return YES;
}

- (BOOL)transitionToSceneWithKey:(NSString*)aSceneKey {
	// If the scene key exists then tell the current scene to transition to that
    // scene and return YES
    if([_scenes objectForKey:aSceneKey]) {
        [currentScene transitionToSceneWithKey:aSceneKey];
        return YES;
    }
    
    // If the scene does not exist then return NO;
    return NO;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
	[_scenes release];
	[currentScene release];
	[super dealloc];
}

@end

