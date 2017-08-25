//
//  EAGLView.m
//
//  Created by James Bishop on 01/02/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/EAGLDrawable.h>
#import <mach/mach.h>
#import <mach/mach_time.h>

#import "EAGLView.h"

#define USE_DEPTH_BUFFER 0

// A class extension to declare private methods
@interface EAGLView ()

@property (nonatomic, retain) EAGLContext *context;

- (BOOL) createFramebuffer;
- (void) destroyFramebuffer;
- (void) drawView;

@end

@implementation EAGLView

@synthesize controller;
@synthesize context;

- (void)dealloc {	
	[controller release];
    if ([EAGLContext currentContext] == context) {
        [EAGLContext setCurrentContext:nil];
    }
    
    [context release];  
    [super dealloc];
}

// You must implement this method
+ (Class)layerClass {
    return [CAEAGLLayer class];
}

- (id)initWithFrame:(CGRect)frame {
	
   if ((self = [super initWithFrame:frame])) {

        _sharedSceneManager = [SceneManager sharedSceneManager];
        
        // Get the layer
        CAEAGLLayer *eaglLayer = (CAEAGLLayer *)self.layer;
        
        eaglLayer.opaque = YES;
        eaglLayer.drawableProperties = [NSDictionary dictionaryWithObjectsAndKeys:
                        [NSNumber numberWithBool:NO], kEAGLDrawablePropertyRetainedBacking, 
                        kEAGLColorFormatRGBA8, kEAGLDrawablePropertyColorFormat, nil];
        
        // iOS 4.0 and up we need to upscale.
        // Work out the retina scaling properties.
        if(USE_RETINA_DISPLAY) {
            UIScreen *mainScreen = [UIScreen mainScreen];
            if([mainScreen respondsToSelector:@selector(scale)]) {
                const CGFloat scale = mainScreen.scale;
                self.contentScaleFactor = scale;
                eaglLayer.contentsScale = scale;

                // Share the scaling factor across scenes.
                [_sharedSceneManager setGraphicsScale:scale];
            }
        }
        
        context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES1];
        
        if (!context || ![EAGLContext setCurrentContext:context]) {
            [self release];
            return nil;
        }
		
		// Init the gameController
		controller = [[GLViewController alloc] initWithFrame:frame];
		
		// Define the absolute starting point of the application run.
		lastTime = CFAbsoluteTimeGetCurrent();
		
    }
    return self;
}

#pragma mark -
#pragma mark Main game loop

- (void)mainGameLoop {
	
	// Create variables to hold the current time and calculated delta
	CFTimeInterval		time;
	float				delta;
	
	// This is the heart of the game loop and will keep on looping until it is told otherwise
    while(true) {
		
        // Create an autorelease pool which can be used within this tight loop.  This is a memory
        // leak when using NSString stringWithFormat in the renderScene method.  Adding a specific
        // autorelease pool stops the memory leak
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        // I found this trick on iDevGames.com.  The command below pumps events which take place
        // such as screen touches etc so they are handled and then runs our code.  This means
        // that we are always in sync with VBL rather than an NSTimer and VBL being out of sync
        while(CFRunLoopRunInMode(kCFRunLoopDefaultMode, 0.002, TRUE) == kCFRunLoopRunHandledSource);
        
        // Get the current time and calculate the delta between the lasttime and now
        time = CFAbsoluteTimeGetCurrent();
        delta = (time - lastTime);
        
        // Go and update the game logic and then render the scene
        [controller updateScene:delta];
        [self drawView];
        
        // Calculate the FPS
        _FPSCounter += delta;
        if(_FPSCounter > 0.25f) {
            _FPSCounter = 0;
            float _fps = (1.0f / (time - lastTime));
            // Set the FPS in the director
            [_sharedSceneManager setFramesPerSecond:_fps];
        }
		
        // Set the lasttime to the current time ready for the next pass
        lastTime = time;
        
        // Release the autorelease pool so that it is drained
        [pool release];
    }
}


- (void)drawView {
	// Set the current EAGLContext and bind to the framebuffer.  This will direct all OGL commands to the
	// framebuffer and the associated renderbuffer attachment which is where our scene will be rendered
	[EAGLContext setCurrentContext:context];
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    
	// Get the game controller to render our scene
	[controller renderScene];
	
	// Bind to the renderbuffer and then present this image to the current context
	glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    [context presentRenderbuffer:GL_RENDERBUFFER_OES];
}

#pragma mark -
#pragma mark Touches

// Pass on all touch events to the game controller including a reference to this view so we can get data
// about this view if necessary
- (void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event {
    //NSLog(@"- EAGLView -> touchesBegan ...");
	[controller touchesBegan:touches withEvent:event view:self];
}

- (void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event {
    //NSLog(@"- EAGLView -> touchesMoved ...");
	[controller touchesMoved:touches withEvent:event view:self];
}

- (void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event {
    //NSLog(@"- EAGLView -> touchesEnded ...");
	[controller touchesEnded:touches withEvent:event view:self];
}

- (void)touchesCancelled:(NSSet*)touches withEvent:(UIEvent*)event {
    //NSLog(@"- EAGLView -> touchesCancelled ...");
	[controller touchesCancelled:touches withEvent:event view:self];
}

- (void)layoutSubviews {	
    [EAGLContext setCurrentContext:context];
    [self destroyFramebuffer];
    [self createFramebuffer];
    [self drawView];
}


- (BOOL)createFramebuffer {
    glGenFramebuffersOES(1, &viewFramebuffer);
    glGenRenderbuffersOES(1, &viewRenderbuffer);
    
    glBindFramebufferOES(GL_FRAMEBUFFER_OES, viewFramebuffer);
    glBindRenderbufferOES(GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    [context renderbufferStorage:GL_RENDERBUFFER_OES fromDrawable:(CAEAGLLayer*)self.layer];
    glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_COLOR_ATTACHMENT0_OES, GL_RENDERBUFFER_OES, viewRenderbuffer);
    
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_WIDTH_OES, &backingWidth);
    glGetRenderbufferParameterivOES(GL_RENDERBUFFER_OES, GL_RENDERBUFFER_HEIGHT_OES, &backingHeight);
    
    if (USE_DEPTH_BUFFER) {
        glGenRenderbuffersOES(1, &depthRenderbuffer);
        glBindRenderbufferOES(GL_RENDERBUFFER_OES, depthRenderbuffer);
        glRenderbufferStorageOES(GL_RENDERBUFFER_OES, GL_DEPTH_COMPONENT16_OES, backingWidth, backingHeight);
        glFramebufferRenderbufferOES(GL_FRAMEBUFFER_OES, GL_DEPTH_ATTACHMENT_OES, GL_RENDERBUFFER_OES, depthRenderbuffer);
    }
    
    if(glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES) != GL_FRAMEBUFFER_COMPLETE_OES) {
        NSLog(@"failed to make complete framebuffer object %x", glCheckFramebufferStatusOES(GL_FRAMEBUFFER_OES));
        return NO;
    }
    
    return YES;
}


- (void)destroyFramebuffer {    
    glDeleteFramebuffersOES(1, &viewFramebuffer);
    viewFramebuffer = 0;
    glDeleteRenderbuffersOES(1, &viewRenderbuffer);
    viewRenderbuffer = 0;
    
    if(depthRenderbuffer) {
        glDeleteRenderbuffersOES(1, &depthRenderbuffer);
        depthRenderbuffer = 0;
    }
}

@end

