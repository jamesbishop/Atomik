//
//  ProgressManager.m
//  Atomik
//
//  Created by James on 2/1/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "ProgressManager.h"
#import "SynthesizeSingleton.h"

@interface ProgressManager (Private)

- (void)clearGameProgress;
- (BOOL)isStagePurchased:(int)stage;

// Standard data handling procedures
- (NSData*)buildJSONObject:(NSDictionary*)jsonData;

@end

@implementation ProgressManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ProgressManager);

- (id)init {
    if (self = [super init]) {
        // Nothing to do at this point.
        _deviceManager = [DeviceManager sharedDeviceManager];
    }
    return self;
}


- (void)openAllStagesAndLevels {
    
#ifdef DEBUG
    //NSLog(@"===== OPEN ALL STAGES AND LEVELS =====");
#endif
    
    // We need a registration file for the audio to work.
    if(![_deviceManager doesFileExist:REGISTRATION_FILE]) {
        [_deviceManager createFile:REGISTRATION_FILE];
    }
    
    int maximumStagesToOpen = STAGES_IN_GAME;
    int maximumLevelsToOpen = LEVELS_PER_STAGE;
    
    // Use the below code for debugging and screenshots of the game for consistency.
    //int maximumStagesToOpen = 1;
    //int maximumLevelsToOpen = 5;
    
    // Loop through all the stages to unlock levels.
    for(int stage=1; stage <= maximumStagesToOpen; stage++) {
        NSString *stageFile = [NSString stringWithFormat:STAGE_FILENAME, stage];
        [_deviceManager createFile:stageFile];
        
        // Loop through all the levels for each stage to unlock.
        for(int level=1; level <= maximumLevelsToOpen; level++) {
            
            // Pick random state limits, so we don't have the same icons for each level.
            int maximumStateForLevel = (int)[UIHelper randomNumberBetweenMinimum:(LEVEL_UNLOCKED+1) andMaximum:TOTAL_ICON_STATES];
            
            // Unlock all the states for the level we are dealing with.
            for(int state=0; state <= maximumStateForLevel; state++) {
                NSString *fileToCreate = [NSString stringWithFormat:LEVEL_FILENAME, stage, level, state];
                [_deviceManager createFile:fileToCreate];
            }
        }
    }
    
    [_deviceManager showDocumentsDirectory];
    
#ifdef DEBUG
    //NSLog(@"=====================================");
#endif
    
}

- (void)clearGameProgress {
    [_deviceManager deleteFile:REGISTRATION_FILE];
    
    for(int stage=1; stage <= STAGES_IN_GAME; stage++) {
        NSString *stageFile = [NSString stringWithFormat:STAGE_FILENAME, stage];
        if([_deviceManager doesFileExist:stageFile]) {
            [_deviceManager deleteFile:stageFile];
        }
        
        for(int level=1; level <= LEVELS_PER_STAGE; level++) {
            for(int state=0; state <= TOTAL_ICON_STATES; state++) {
                NSString *fileToDelete = [NSString stringWithFormat:LEVEL_FILENAME, stage, level, state];
                if([_deviceManager doesFileExist:fileToDelete]) {
                    [_deviceManager deleteFile:fileToDelete];
                }
            }
        }
    }
}

- (NSData*)buildJSONObject:(NSDictionary*)json {
    NSError *error = nil;
    if([NSJSONSerialization isValidJSONObject:json]) {
        return [NSJSONSerialization dataWithJSONObject:json options:kNilOptions error:&error];
    }
    
    return [NSData dataWithContentsOfFile:REGISTRATION_FILE];
}

- (void)checkGameRegistration {

    // Debug only, show what registration file we are creating (to be removed)
#ifdef DEBUG
    //NSLog(@"Checking Game Registration: [%@] ...", REGISTRATION_FILE);
#endif

    // Remove all our registration information, for debugging purposes (not live!)
    if(CLEAR_REGISTRATION) {
        [_deviceManager clearDocumentsDirectory];
    }
    
    // Check if the file does not exist, as we need to maintain a single store this.
    if(![_deviceManager doesFileExist:REGISTRATION_FILE]) {

        // Registration file does not exist, so create and maintain our registration information.
        progressData = [[ProgressData alloc] init];
        [progressData setDeviceID:[[DeviceManager sharedDeviceManager] createNewUUID]];
        
        UIDevice *device = [[UIDevice alloc] init];
        [progressData setPlatform:[device platform]];
        [device release];

        [progressData setVersion:GAME_VERSION];
        [progressData setMusicVolume:DEFAULT_MUSIC_VOLUME];
        [progressData setEffectsVolume:DEFAULT_EFFECTS_VOLUME];
        
        [self saveProgressData:progressData];
        
        // Unlock the first stage so that the users have something to play.
        [self unlockStage:1];
        [self unlockStage:1 withLevel:1];
        
    } else {
        [self loadProgressData];
    }

    // For debugging purposes. we need a way to open up all the game levels.
    if(OPEN_ALL_CONTENT) {
        [self openAllStagesAndLevels];
    }
}

- (ProgressData*)getProgressData {
    return progressData;
}

- (ProgressData*)loadProgressData {
    
    // Kill any existing references to the existing configuration.
    if(progressData) {
        [progressData release];
    }
    
    // Load the raw data for this menu from our configuration.
    NSData *data = [_deviceManager readDataFromFile:REGISTRATION_FILE];
    
    // Create and store the stage menu container object.
    progressData = [[ProgressData alloc] init];
    
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
        if([object isKindOfClass:[NSDictionary class]]) {
            NSDictionary *results = object;
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
            
            [progressData setDeviceID:[results objectForKey:@"device-id"]];
            [progressData setPlatform:[results objectForKey:@"platform"]];
            [progressData setVersion:[results objectForKey:@"version"]];
            [progressData setMusicVolume:[[results objectForKey:@"music-volume"] floatValue]];
            [progressData setEffectsVolume:[[results objectForKey:@"effects-volume"] floatValue]];
            
        } else {
            /* there's no guarantee that the outermost object in a JSON
             packet will be a dictionary; if we get here then it wasn't,
             so 'object' shouldn't be treated as an NSDictionary; probably
             you need to report a suitable error condition */
        }
    } else {
        // the user is using iOS 4; we'll need to use a third-party solution.
        // If you don't intend to support iOS 4 then get rid of this entire
        // conditional and just jump straight to
        // NSError *error = nil;
        // [NSJSONSerialization JSONObjectWithData:...
    }
    
    //NSLog(@"%@", [progressData content]);
    
    return progressData;
}

- (void)saveProgressData:(ProgressData*)data {
    // Define the JSON data that we need to persist to the file for further usage.
    NSData *jsonData = [self buildJSONObject:[data content]];
    
    // Finally, persist the data to file in a JSON format for further usage.
    [_deviceManager writeDataToFile:REGISTRATION_FILE data:jsonData];
}

- (BOOL)isStageUnlocked:(int)stage {
    //[_deviceManager showDocumentsDirectory];
    return [_deviceManager doesFileExist:[NSString stringWithFormat:STAGE_FILENAME, stage]];
}

- (BOOL)isStageUnlocked:(int)stage withLevel:(int)level {
    return [_deviceManager doesFileExist:[NSString stringWithFormat:LEVEL_FILENAME, stage, level, 1]];
}

- (int)getStateForStage:(int)stage withLevel:(int)level {
    for(int state=0; state <= TOTAL_ICON_STATES; state++) {
        NSString *fileToCheck = [NSString stringWithFormat:LEVEL_FILENAME, stage, level, state];
        if(![_deviceManager doesFileExist:fileToCheck]) {
            return (state > 0) ? (state-1) : state;
        }
    }
    return TOTAL_ICON_STATES;
}

- (BOOL)setState:(int)state withStage:(int)stage andLevel:(int)level {
    for(int unlock=0; unlock <= state; unlock++) {
        NSString *fileToCreate = [NSString stringWithFormat:LEVEL_FILENAME, stage, level, unlock];
        if(![_deviceManager doesFileExist:fileToCreate]) {
            [_deviceManager createFile:fileToCreate];
        }
    }
    return YES;
}

- (BOOL)unlockStage:(int)stage {
    return [_deviceManager createFile:[NSString stringWithFormat:STAGE_FILENAME, stage]];
}

- (BOOL)unlockStage:(int)stage withLevel:(int)level {
    for(int state=0; state <= 1; state++) {
        NSString *fileToCreate = [NSString stringWithFormat:LEVEL_FILENAME, stage, level, state];
        if(![_deviceManager doesFileExist:fileToCreate]) {
            [_deviceManager createFile:fileToCreate];
        }
    }
    return YES;
}

- (BOOL)isStagePurchased:(int)stage {
    return YES;
}

- (void)updateStage:(int)stage withLevel:(int)level andState:(int)state {
    if([self setState:state withStage:stage andLevel:level]) {
        
        // If we haven't beaten the level, then don't open anything up.
        if(state <= 1) {
            return;
        }
        
        // Level complete, so setup the game progress to reflect this.
        if(level < LEVELS_PER_STAGE) {
            [self unlockStage:stage withLevel:(level+1)];
        } else {
            int nextStage = (stage+1);
            if([self isStagePurchased:nextStage]) {
                [self unlockStage:nextStage];
                [self unlockStage:nextStage withLevel:1];
            }
        }
    }
}

- (void)dealloc {
    [super dealloc];
    [progressData release];
}

@end
