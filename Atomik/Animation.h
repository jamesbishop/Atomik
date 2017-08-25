//
//  Animation.h
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "SpriteSheet.h"
#import "Frame.h"

enum {
	kDirection_Forward = 1,
	kDirection_Backwards = -1
};

@interface Animation : NSObject<NSCopying> {
	NSMutableArray *frames;			// Frames to be used within this animation	
	float frameTimer;				// Accumulates the time while a frame is displayed
	float frameLength;				// The total length of a single animation cycle
	float width;					// The width of this animation
	float height;					// The height of this animation
	BOOL running;					// Holds the animation running state	
	BOOL repeat;					// Repeat the animation an infinate amount of times
	BOOL pingPong;					// Should the animation ping pong backwards and forwards
	int direction;					// Direction in which the animation is running
	int currentFrame;				// The current frame of animation
}

@property(nonatomic, readonly)float width;
@property(nonatomic, readonly)float height;
@property(nonatomic)BOOL running;
@property(nonatomic)BOOL repeat;
@property(nonatomic)BOOL pingPong;
@property(nonatomic)int currentFrame;
@property(nonatomic)int direction;

- (void)addFrameWithImage:(Image*)image delay:(float)delay;
- (void)update:(float)delta;
- (void)renderAtPoint:(CGPoint)point;
- (void)renderAtPoint:(CGPoint)point scale:(float)scale;
- (Image*)getCurrentFrameImage;
- (GLuint)getAnimationFrameCount;
- (GLuint)getCurrentFrameNumber;
- (Frame*)getFrame:(GLuint)frameNumber;
- (void)flipAnimationVertically:(BOOL)flipVertically horizontally:(BOOL)flipHorizontally;

@end
