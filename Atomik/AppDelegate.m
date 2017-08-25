//
//  AppDelegate.m
//
//  Created by James Bishop on 1/15/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "AppDelegate.h"
#import "EAGLView.h"

@implementation AppDelegate

- (void)dealloc {
    [window release];
    [glView release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	// We're not using the standard NIB files anymore, we are creating the window and the
    // EAGLView manually. This avoids the need to use Interface Builder (very confusing).
    window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
	[window setUserInteractionEnabled:YES];
	[window setMultipleTouchEnabled:YES];
	
	// Now we need to setup our OpenGL view, for our software rendering pipeline.
	glView = [[EAGLView alloc] initWithFrame:[UIScreen mainScreen].bounds];
	
    // Add the glView to the window which has been defined
	[window addSubview:glView];
    [window setRootViewController:glView.controller];
	[window makeKeyAndVisible];
    
	// Adjust the device orientation to landscape for wide rendering context.
	//[[UIDevice currentDevice] setOrientation:UIInterfaceOrientationLandscapeRight];
	
	// Since OS 3.0, just calling [glView mainGameLoop] did not work, you just got a black screen.
    // It appears that others have had the same problem and to fix it you need to use the 
    // performSelectorOnMainThread call below.
    [glView performSelectorOnMainThread:@selector(mainGameLoop) withObject:nil waitUntilDone:NO]; 	
    
    // Fix added to remove the battery indicator and status bar information in iOS7 only.
    float deviceVersion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if (deviceVersion >= 7) {
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
        
        //self.window.clipsToBounds = YES;
        //self.window.frame = CGRectMake(0,20,self.window.frame.size.width,self.window.frame.size.height-20);
        
    } else {
        [application setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    }
    
    // Alert the delegate that the application has indeed finished launching with options.
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    //NSLog(@"AppDelegate:applicationWillResignActive");
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    //NSLog(@"AppDelegate:applicationDidEnterBackground");
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    //NSLog(@"AppDelegate:applicationWillEnterForeground");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    //NSLog(@"AppDelegate:applicationDidBecomeActive");
}

- (void)applicationWillTerminate:(UIApplication *)application {
    //NSLog(@"AppDelegate:applicationWillTerminate");
}

@end
