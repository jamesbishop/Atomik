//
//  SingletonGameState.h
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES1/gl.h>

@interface SingletonGameState : NSObject {
	GLuint currentlyBoundTexture;
}

@property (nonatomic, assign) GLuint currentlyBoundTexture;

+ (SingletonGameState*)sharedGameStateInstance;

@end
