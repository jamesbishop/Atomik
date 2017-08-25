//
//  SceneManager.h
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>

@class AbstractScene;

@interface SceneManager : NSObject {	
	GLuint currentlyBoundTexture;		// Currently bound texture name	
	GLuint currentGameState;			// Current game state	
	AbstractScene *currentScene;		// Current scene	
	NSMutableDictionary *_scenes;		// Dictionary of scenes	
	GLfloat globalAlpha;				// Global alpha
	float framesPerSecond;				// Frames Per Second
    float graphicsScale;                // Viewport Scale
}
	
@property (nonatomic, assign) GLuint currentlyBoundTexture;
@property (nonatomic, assign) GLuint currentGameState;
@property (nonatomic, retain) AbstractScene *currentScene;
@property (nonatomic, assign) GLfloat globalAlpha;
@property (nonatomic, assign) float framesPerSecond;
@property (nonatomic, assign) float graphicsScale;

+ (id)sharedSceneManager;
- (void)addSceneWithKey:(NSString*)aSceneKey scene:(AbstractScene*)aScene;
- (BOOL)setCurrentSceneToSceneWithKey:(NSString*)aSceneKey;
- (BOOL)transitionToSceneWithKey:(NSString*)aSceneKey;

@end
