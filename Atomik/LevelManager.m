//
//  LevelManager.m
//  Atomik
//
//  Created by James Bishop on 9/15/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "LevelManager.h"

@interface LevelManager (Private)
- (Level*)buildLevelWithData:(NSData*)data;
- (NSMutableArray*)buildLevelSinkholes:(NSDictionary*)data;
- (NSMutableArray*)buildLevelSpawnpods:(NSDictionary*)data;
@end

@implementation LevelManager

SYNTHESIZE_SINGLETON_FOR_CLASS(LevelManager);

- (id)init {
    self = [super init];
	if (self != nil) {
        _imageManager = [ImageManager sharedImageManager];
    }
	return self;
}

- (NSMutableArray*)buildLevelSinkholes:(NSDictionary *)data {
    return nil;
}

- (NSMutableArray*)buildLevelSpawnpods:(NSDictionary *)data {
    return nil;
}

- (Level*)buildLevelWithData:(NSData *)data {

    // We need to instantiate our level data here for procesing.
    Level *loadLevel = [[Level alloc] init];

    // Probably check here that returnedData isn't nil; attempting
    // NSJSONSerialization with nil data raises an exception, and who
    // knows how your third-party library intends to react?
    
    NSError *error = nil;
    
    if(NSClassFromString(@"NSJSONSerialization"))
    {
        id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        
        if(error) {
            /* JSON was malformed, act appropriately here */
            //[[NSAlert alertWithError:error] runModal];
        }
        
        // the originating poster wants to deal with dictionaries;
        // assuming you do too then something like this is the first
        // validation step:
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *results = object;
            
            // Proceed with results as you like; the assignment to an explicit
            // NSDictionary is artificial step to get compile-time checking
            // from here on down (and better autocompletion when editing).
            // You could have just made object an NSDictionary in the first
            // place but stylistically you might prefer to keep the question
            // of type open until it's confirmed.
            
            [loadLevel setTitle:[results objectForKey:@"title"]];
            [loadLevel setBackground:[results objectForKey:@"background"]];
            [loadLevel setPipeline:[results objectForKey:@"pipeline"]];
            [loadLevel setScoreboard:[results objectForKey:@"scoreboard"]];
            [loadLevel setMusic:[results objectForKey:@"music"]];
            [loadLevel setDuration:[[results objectForKey:@"duration"] floatValue]];
            [loadLevel setLives:[[results objectForKey:@"lives"] integerValue]];
            [loadLevel setTarget:[[results objectForKey:@"target"] floatValue]];
            
            NSArray *sinkholes = [results objectForKey:@"sinkholes"];
            for(int i=0; i < [sinkholes count]; i++) {
                NSDictionary *sinkhole = [sinkholes objectAtIndex:i];
                int id = [[sinkhole objectForKey:@"id"] integerValue];
                float x = [[sinkhole objectForKey:@"x"] floatValue];
                float y = [[sinkhole objectForKey:@"y"] floatValue];
                
                NSString *imageName = [NSString stringWithFormat:@"Sinkhole_%d", id];
                
                Image *sinkholeImage = [[_imageManager getImageWithName:imageName] retain];
                BasicSinkhole *newSinkhole = [[BasicSinkhole alloc] initWithImage:sinkholeImage atPoint:CGPointMake(x, y)];
                [newSinkhole setID:id];
                [[loadLevel sinkholes] addObject:newSinkhole];
                [newSinkhole release];
                [sinkholeImage release];
            }
            
            NSArray *spawnpods = [results objectForKey:@"spawnpods"];
            for(int i=0; i < [spawnpods count]; i++) {
                NSDictionary *spawnpod = [spawnpods objectAtIndex:i];
                int id = [[spawnpod objectForKey:@"id"] integerValue];
                NSString *type = [spawnpod objectForKey:@"type"];
                float x = [[spawnpod objectForKey:@"x"] floatValue];
                float y = [[spawnpod objectForKey:@"y"] floatValue];
                int direction = [[spawnpod objectForKey:@"direction"] integerValue];
                int visible = [[spawnpod objectForKey:@"visible"] integerValue];
                float delay = [[spawnpod objectForKey:@"delay"] floatValue];
                float speed = [[spawnpod objectForKey:@"speed"] floatValue];
                int state = [[spawnpod objectForKey:@"state"] integerValue];
                
                AbstractSpawnpod *pod = nil;
                if([type isEqualToString:@"spawn"]) {
                    pod = [[SpawnPod alloc] initAtPoint:CGPointMake(x, y)];
                } else {
                    pod = [[SteamPod alloc] initAtPoint:CGPointMake(x, y)];
                    
                    int sheet_width = 256, sheet_height = 256;
                    int sprite_width = 64, sprite_height = 64;
                    int rows = (sheet_height / sprite_height);
                    int cols = (sheet_width / sprite_width);
                    float sprite_delay = 0.05f;
                    float sprite_scale = 1.00f;
                    
                    // FIXME: We need to allocate the animation here.
                    NSString *sheetName = [NSString stringWithFormat:@"Explosion_(%dx%d).png", sheet_width, sheet_height];
                    SpriteSheet *sheet = [[SpriteSheet alloc] initWithImageNamed:sheetName spriteWidth:sprite_width
                            spriteHeight:sprite_height spacing:0 imageScale:sprite_scale];
                    
                    Animation *animation = [[Animation alloc] init];
                    for(int row=0; row < rows; row++) {
                        for(int col=0; col < cols; col++) {
                            [animation addFrameWithImage:[sheet getSpriteAtX:col y:row] delay:sprite_delay];
                        }
                    }
                    [animation setRunning:NO];
                    [animation setRepeat:NO];
                    
                    [(SteamPod*)pod setAnimation:animation];
                    
                    [sheet release];
                    [animation release];
                    
                    [(SteamPod*)pod setIdleImage:[_imageManager getImageWithKey:@"SteamPod_0"]];
                    [(SteamPod*)pod setActiveImage:[_imageManager getImageWithKey:@"SteamPod_1"]];

                }
                [pod setPodID:id];
                [pod setDirection:direction];
                [pod setVisibility:visible];
                [pod setState:state];
                [pod setDelay:delay];
                [pod setSpeed:speed];
                
                [[loadLevel spawnpods] addObject:pod];
                
                [pod release];
                
                /*
                NSLog(@"Adding SpawnPod: [id=%i, type=%@, x=%.2f, y=%.3f, direction=%d, visible=%d, delay=%.3f, speed=%.3f, state=%d (%lu)]",
                      id, type, x, y, direction, visible, delay, speed, state, (unsigned long)[loadLevel sinkholes].count);
                 */
            }
            
        }
        else
        {
            /* there's no guarantee that the outermost object in a JSON
             packet will be a dictionary; if we get here then it wasn't,
             so 'object' shouldn't be treated as an NSDictionary; probably
             you need to report a suitable error condition */
        }
    }
    else
    {
        // the user is using iOS 4; we'll need to use a third-party solution.
        // If you don't intend to support iOS 4 then get rid of this entire
        // conditional and just jump straight to
        // NSError *error = nil;
        // [NSJSONSerialization JSONObjectWithData:...
    }
    
    return loadLevel;
}

- (Level*)loadFromDeviceWithStage:(int)stage andLevel:(int)level andWidth:(int)width andHeight:(int)height {
    // Load the game data in raw format for processing.
    NSString *filename = [NSString stringWithFormat:@"S%d_L%d_(%dx%d)", stage, level, width, height];
    NSString *fullpath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    
    NSData *data = [NSData dataWithContentsOfFile:fullpath];
    
    return [self buildLevelWithData:data];
}

- (Level*)loadFromServerWithStage:(int)stage andLevel:(int)level andWidth:(int)width andHeight:(int)height {
    return nil;
}

@end
