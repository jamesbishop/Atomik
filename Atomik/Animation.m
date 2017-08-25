//
//  Animation.m
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import "Animation.h"

@implementation Animation

@synthesize width;
@synthesize height;
@synthesize currentFrame;
@synthesize direction;
@synthesize running;
@synthesize repeat;
@synthesize pingPong;

- (id)init {
	self = [super init];
	if(self != nil) {
		// Initialize the array which will hold our frames
		frames = [[NSMutableArray alloc] init];
		
		// Set the default values for important properties
		currentFrame = 0;
		frameTimer = 0;
		frameLength = 0.0f;
		running = NO;
		repeat = NO;
		pingPong = NO;
		direction = kDirection_Forward;
	}
	return self;
}

- (void)addFrameWithImage:(Image*)image delay:(float)delay {	
	// Create a new frame instance which will hold the frame image and delay for that image
	Frame *frame = [[Frame alloc] initWithImage:image delay:delay];
	
	// Set the dimensions of this animation for rendering purposes
	width = [image imageWidth];
	height = [image imageHeight];
	
	// Add the frame to the array of frames in this animation
	[frames addObject:frame];
	
	// Add the length of this frame to the total length of the animation
	frameLength += delay;
	
	// Release the frame instance created as having added it to the array will have put its
	// retain count up to 2 so the object we need will not be released until we are finished
	[frame release];
}

- (void)update:(float)delta {
	// If not running, reset frame counter and don't bother with updating animation sequences.
	if(!running) {
		return;
	}
	
	// Update the timer with the delta
	frameTimer += delta;

	// If the timer has exceed the delay for the current frame, move to the next frame.  If we are at
	// the end of the animation, check to see if we should repeat, pingpong or stop
	if(frameTimer > [[frames objectAtIndex:currentFrame] frameDelay]) {
		currentFrame += direction;
		frameTimer = 0;

		// Check if we have passed the frames boundaries
		if(currentFrame > [frames count]-1 || currentFrame < 0) {
			
			// The following code was provided by akucsai (Antal) on the 71Squared blog
			if(!pingPong) {
				if(repeat) {
					// If we should repeat without ping pong then just reset the current frame to 0 and carry on
					currentFrame = 0;
					
				} else {
					// If we are not repeating and no pingPing then set the current frame to 0 and stop the animation
					running = NO;
					currentFrame = 0;
				}
			} else {
				// If we are ping ponging then change the direction and move the current frame to the
				// next frame based on the direction
				direction = -direction;
				currentFrame += direction;
			}
		}
	}
}

- (Image*)getCurrentFrameImage {
	// Return the image which is being used for the current frame
	return [[frames objectAtIndex:currentFrame] frameImage];
}

- (GLuint)getAnimationFrameCount {
	// Return the total number of frames in this animation
	return (GLuint)[frames count];
}

- (GLuint)getCurrentFrameNumber {
	// Return the current frame within this animation
	return currentFrame;
}

- (Frame*)getFrame:(GLuint)frameNumber {	
	// If a frame number is reuqested outside the range that exists, return nil
	// and report an error (which has been disabled for development/production).
	if(frameNumber > [frames count]) {
		return nil;
	}
	
	// Return the frame for the requested index (from the allocated frame buffer)
	return [frames objectAtIndex:frameNumber];
}

- (void)flipAnimationVertically:(BOOL)flipVertically horizontally:(BOOL)flipHorizontally {
	for(int index=0; index < [frames count]; index++) {
		[[[frames objectAtIndex:index] frameImage] setFlipVertically:flipVertically];
		[[[frames objectAtIndex:index] frameImage] setFlipHorizontally:flipHorizontally];
	}
}

- (void)renderAtPoint:(CGPoint)point {
	// If we are not running, don't bother rendering.
	if(!running) {
		return;
	}
	
	// Get the current frame for this animation
	Frame *frame = [frames objectAtIndex:currentFrame];
	
	// Take the image for this frame and render it at the point provided, but default
	// animations are rendered with their centre at the point provided
	[[frame frameImage] renderAtPoint:point centerOfImage:YES];
}

- (void)renderAtPoint:(CGPoint)point scale:(float)scale {
	// If we are not running, don't bother rendering.
	if(!running) {
		return;
	}
	
	// Adjust the scale of this image instance
	Image *image = [[frames objectAtIndex:currentFrame] frameImage];
	[image setScale:scale];
	[image renderAtPoint:point centerOfImage:YES];
}

// We want to clone this object, as opposed to recreating it.
-(id)copyWithZone:(NSZone*)zone
{
    // We'll ignore the zone for now
    Animation *another = [[Animation alloc] init];
    another->frames = [frames copyWithZone:zone];
    
    return another;
}

- (void)dealloc {	
	[frames release];
	[super dealloc];
}
@end
