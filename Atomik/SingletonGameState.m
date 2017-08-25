//
//  SingletonGameState.m
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import "SingletonGameState.h"


@implementation SingletonGameState

@synthesize currentlyBoundTexture;

+ (SingletonGameState*)sharedGameStateInstance {
	
	static SingletonGameState *sharedGameStateInstance;
	
	@synchronized(self) {
		if(!sharedGameStateInstance) {
			sharedGameStateInstance = [[SingletonGameState alloc] init];
		}
	}
	
	return sharedGameStateInstance;
}

- (void) dealloc {
	[super dealloc];
}

@end
