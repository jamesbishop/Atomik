//
//  ConfigManager.m
//  Atomik
//
//  Created by James on 11/21/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "ConfigManager.h"
#import "SynthesizeSingleton.h"

@interface ConfigManager (Private)
- (NSData*)loadData:(NSString*)menufile;
@end

@implementation ConfigManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ConfigManager);

- (id)init {
    if (self = [super init]) {
        // Nothing to do in the initialisation sequence.
    }
    return self;
}

- (NSData*)loadDataForMenu:(NSString*)menufile andWidth:(int)width andHeight:(int)height {

    // Load the game data in raw format for processing.
    NSString *filename = [NSString stringWithFormat:@"%@_(%dx%d)", menufile, width, height];
    NSString *fullpath = [[NSBundle mainBundle] pathForResource:filename ofType:@"json"];
    //NSLog(@"Loading Config: [%@] ...", fullpath);
    
    NSData *data = [NSData dataWithContentsOfFile:fullpath];
    //NSLog(@" Config Length: [%lu]", (unsigned long)[data length]);
    
    return data;
}

- (void)loadAudioConfigWithWidth:(int)width andHeight:(int)height {
    
    // Load the raw data for this menu.
    NSData *data = [self loadDataForMenu:@"Audio_Config" andWidth:width andHeight:height];
    
    // Create and store the stage menu container object.
    audioConfig = [[AudioConfig alloc] init];
    
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
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
            
            [audioConfig setSceneTitle:[results objectForKey:@"scene-title"]];
            [audioConfig setSceneImage:[results objectForKey:@"scene-image"]];
            [audioConfig setSceneMusic:[results objectForKey:@"scene-music"]];
            
            int titleX = [[results objectForKey:@"scene-title-x"] integerValue];
            int titleY = [[results objectForKey:@"scene-title-y"] integerValue];
            CGPoint titlePosition = CGPointMake(titleX, titleY);
            [audioConfig setTitlePosition:titlePosition];
            
            NSArray *sliders = [results objectForKey:@"sliders"];
            for(int i=0; i < [sliders count]; i++) {
                NSDictionary *object = [sliders objectAtIndex:i];
                NSString *id = [object objectForKey:@"id"];
                int w = [[object objectForKey:@"w"] integerValue];
                int h = [[object objectForKey:@"h"] integerValue];
                int x = [[object objectForKey:@"x"] integerValue];
                int y = [[object objectForKey:@"y"] integerValue];
                int min = [[object objectForKey:@"min"] integerValue];
                int max = [[object objectForKey:@"max"] integerValue];
                
                float headerY = [[object objectForKey:@"header_y"] floatValue];
                CGPoint headerText = CGPointMake(x, headerY);
                
                float volumeY = [[object objectForKey:@"volume_y"] floatValue];
                CGPoint volumeText = CGPointMake(x, volumeY);
                
                CGPoint position = CGPointMake(x, y);
                CGSize size = CGSizeMake(w, h);
                
                UISliderControl *slider = [[UISliderControl alloc] initWithName:id withSize:size atPosition:position];
                [slider setMinimum:min];
                [slider setMaximum:max];
                [slider setTitleText:headerText];
                [slider setVolumeText:volumeText];
                
                [[audioConfig sliders] addObject:slider];
                
                [slider release];
            }
            
            NSArray *buttons = [results objectForKey:@"buttons"];
            for(int i=0; i < [buttons count]; i++) {
                NSDictionary *object = [buttons objectAtIndex:i];
                NSString *id = [object objectForKey:@"id"];
                int w = [[object objectForKey:@"w"] integerValue];
                int h = [[object objectForKey:@"h"] integerValue];
                int x = [[object objectForKey:@"x"] integerValue];
                int y = [[object objectForKey:@"y"] integerValue];
                
                CGPoint position = CGPointMake(x, y);
                CGRect bounds = CGRectMake(x-(w/2), y-(h/2), w, h);
                
                UIFadeButton *button = [[UIFadeButton alloc] init];
                [button setID:id];
                [button setBounds:bounds];
                [button setPosition:position];
                [button setState:0];
                
                [[audioConfig buttons] addObject:button];
                
                [button release];
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
    
    //NSLog(@"-> Sliders: %d", [audioConfig sliders].count);
}

- (void)loadMenuConfigWithWidth:(int)width andHeight:(int)height {
    
    // Load the raw data for this menu.
    NSData *data = [self loadDataForMenu:@"Menu_Config" andWidth:width andHeight:height];
    
    // Create and store the stage menu container object.
    menuConfig = [[MenuConfig alloc] init];
    
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
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
            
            [menuConfig setSceneTitle:[results objectForKey:@"scene-title"]];
            [menuConfig setSceneImage:[results objectForKey:@"scene-image"]];
            [menuConfig setSceneMusic:[results objectForKey:@"scene-music"]];
            [menuConfig setMenuTitleX:[[results objectForKey:@"scene-title-x"] integerValue]];
            [menuConfig setMenuTitleY:[[results objectForKey:@"scene-title-y"] integerValue]];
            [menuConfig setIconTitleY:[[results objectForKey:@"icon-title-y"] integerValue]];
            
            NSArray *buttons = [results objectForKey:@"buttons"];
            for(int i=0; i < [buttons count]; i++) {
                NSDictionary *object = [buttons objectAtIndex:i];
                NSString *id = [object objectForKey:@"id"];
                int w = [[object objectForKey:@"w"] integerValue];
                int h = [[object objectForKey:@"h"] integerValue];
                int x = [[object objectForKey:@"x"] integerValue];
                int y = [[object objectForKey:@"y"] integerValue];
                
                CGPoint position = CGPointMake(x, y);
                CGRect bounds = CGRectMake(x-(w/2), y-(h/2), w, h);
                
                UIFadeButton *button = [[UIFadeButton alloc] init];
                [button setID:id];
                [button setBounds:bounds];
                [button setPosition:position];
                [button setState:0];
                
                [[menuConfig buttons] addObject:button];
                
                [button release];
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
}

- (void)loadStageConfigWithWidth:(int)width andHeight:(int)height {
    
    // Load the raw data for this menu.
    NSData *data = [self loadDataForMenu:@"Stage_Config" andWidth:width andHeight:height];
    
    // Create and store the stage menu container object.
    stageConfig = [[StageConfig alloc] init];
    
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
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
            
            [stageConfig setSceneTitle:[results objectForKey:@"scene-title"]];
            [stageConfig setSceneImage:[results objectForKey:@"scene-image"]];
            [stageConfig setSceneMusic:[results objectForKey:@"scene-music"]];
            
            int titleX = [[results objectForKey:@"scene-title-x"] integerValue];
            int titleY = [[results objectForKey:@"scene-title-y"] integerValue];
            CGPoint titlePosition = CGPointMake(titleX, titleY);
            [stageConfig setTitlePosition:titlePosition];
            
            [stageConfig setIconFontY:[[results objectForKey:@"icon-font-y"] integerValue]];
            
            NSArray *icons = [results objectForKey:@"icons"];
            for(int i=0; i < [icons count]; i++) {
                NSDictionary *icon = [icons objectAtIndex:i];
                int id = [[icon objectForKey:@"id"] integerValue];
                int w = [[icon objectForKey:@"w"] integerValue];
                int h = [[icon objectForKey:@"h"] integerValue];
                int x = [[icon objectForKey:@"x"] integerValue];
                int y = [[icon objectForKey:@"y"] integerValue];
                
                CGPoint position = CGPointMake(x, y);
                CGRect bounds = CGRectMake(x-(w/2), y-(h/2), w, h);
                
                UIFadeButton *button = [[UIFadeButton alloc] init];
                [button setID:[NSString stringWithFormat:@"%i", id]];
                [button setBounds:bounds];
                [button setPosition:position];
                [button setState:0];
                
                [[stageConfig icons] addObject:button];
                
                [button release];
            }
            
            NSArray *buttons = [results objectForKey:@"buttons"];
            for(int i=0; i < [buttons count]; i++) {
                NSDictionary *icon = [buttons objectAtIndex:i];
                NSString *id = [icon objectForKey:@"id"];
                int x = (int)[[icon objectForKey:@"x"] integerValue];
                int y = (int)[[icon objectForKey:@"y"] integerValue];
                int w = (int)[[icon objectForKey:@"w"] integerValue];
                int h = (int)[[icon objectForKey:@"h"] integerValue];
                
                CGPoint position = CGPointMake(x, y);
                CGRect bounds = CGRectMake(x-(w/2), y-(h/2), w, h);
                
                UIFadeButton *button = [[UIFadeButton alloc] init];
                [button setID:id];
                [button setBounds:bounds];
                [button setPosition:position];
                [button setState:0];
                
                [[stageConfig buttons] addObject:button];
                
                [button release];
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
}

- (void)loadDailyConfigWithWidth:(int)width andHeight:(int)height {
    
    // Load the raw data for this menu.
    NSData *data = [self loadDataForMenu:@"Daily_Config" andWidth:width andHeight:height];
    
    // Create and store the stage menu container object.
    dailyConfig = [[DailyConfig alloc] init];
    
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
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
            
            [dailyConfig setSceneTitle:[results objectForKey:@"scene-title"]];
            [dailyConfig setSceneImage:[results objectForKey:@"scene-image"]];
            [dailyConfig setSceneMusic:[results objectForKey:@"scene-music"]];
            
            float titleX = [[results objectForKey:@"scene-title-x"] floatValue];
            float titleY = [[results objectForKey:@"scene-title-y"] floatValue];
            
            [dailyConfig setTitlePosition:CGPointMake(titleX, titleY)];
            
            NSArray *details = [results objectForKey:@"details"];
            for(int i=0; i < [details count]; i++) {
                NSDictionary *detail = [details objectAtIndex:i];
                
                NSString *text = [detail objectForKey:@"id"];
                int x = [[detail objectForKey:@"x"] integerValue];
                int y = [[detail objectForKey:@"y"] integerValue];

                CGPoint position = CGPointMake(x, y);

                UITextLabel *label = [[UITextLabel alloc] initWithText:text andPosition:position withAlignment:1];
                [[dailyConfig details] addObject:label];
                [label release];
            }
            
            NSArray *buttons = [results objectForKey:@"buttons"];
            for(int i=0; i < [buttons count]; i++) {
                NSDictionary *icon = [buttons objectAtIndex:i];
                NSString *id = [icon objectForKey:@"id"];
                int x = (int)[[icon objectForKey:@"x"] integerValue];
                int y = (int)[[icon objectForKey:@"y"] integerValue];
                int w = (int)[[icon objectForKey:@"w"] integerValue];
                int h = (int)[[icon objectForKey:@"h"] integerValue];
                
                CGPoint position = CGPointMake(x, y);
                CGRect bounds = CGRectMake(x-(w/2), y-(h/2), w, h);
                
                UIFadeButton *button = [[UIFadeButton alloc] init];
                [button setID:id];
                [button setBounds:bounds];
                [button setPosition:position];
                [button setState:0];
                
                [[dailyConfig buttons] addObject:button];
                
                [button release];
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
}

- (void)loadScoreConfigWithWidth:(int)width andHeight:(int)height {
    // Load the raw data for this menu.
    NSData *data = [self loadDataForMenu:@"Score_Config" andWidth:width andHeight:height];
    
    // Create and store the stage menu container object.
    scoreConfig = [[ScoreConfig alloc] init];
    
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
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
            
            [scoreConfig setSceneTitle:[results objectForKey:@"scene-title"]];
            [scoreConfig setSceneImage:[results objectForKey:@"scene-image"]];
            [scoreConfig setSceneMusic:[results objectForKey:@"scene-music"]];
            
            float titleX = [[results objectForKey:@"scene-title-x"] floatValue];
            float titleY = [[results objectForKey:@"scene-title-y"] floatValue];
            
            [scoreConfig setTitlePosition:CGPointMake(titleX, titleY)];
            
            NSArray *details = [results objectForKey:@"details"];
            for(int i=0; i < [details count]; i++) {
                NSDictionary *detail = [details objectAtIndex:i];
                
                NSString *text = [detail objectForKey:@"id"];
                int x = [[detail objectForKey:@"x"] integerValue];
                int y = [[detail objectForKey:@"y"] integerValue];
                
                CGPoint position = CGPointMake(x, y);
                
                UITextLabel *label = [[UITextLabel alloc] initWithText:text andPosition:position withAlignment:1];
                [[scoreConfig details] addObject:label];
                [label release];
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
}

- (void)loadGameConfigWithWidth:(int)width andHeight:(int)height {
    
    // Load the raw data for this menu.
    NSData *data = [self loadDataForMenu:@"Game_Config" andWidth:width andHeight:height];
    
    // Create and store the stage menu container object.
    gameConfig = [[GameConfig alloc] init];
    
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
            //NSDictionary *results = object;
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
            
            //[gameConfig setMusicVolume:[[results objectForKey:@"music-volume"] floatValue]];
            //[gameConfig setEffectsVolume:[[results objectForKey:@"menu-font"] floatValue]];
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
}

- (void)loadCreditsConfigWithWidth:(int)width andHeight:(int)height {
    // Load the raw data for this menu.
    NSData *data = [self loadDataForMenu:@"Credits_Config" andWidth:width andHeight:height];
    
    // Create and store the stage menu container object.
    creditsConfig = [[CreditsConfig alloc] init];
    
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
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
            
            [creditsConfig setSceneTitle:[results objectForKey:@"scene-title"]];
            [creditsConfig setSceneImage:[results objectForKey:@"scene-image"]];
            [creditsConfig setSceneMusic:[results objectForKey:@"scene-music"]];

            float titleX = [[results objectForKey:@"scene-title-x"] floatValue];
            float titleY = [[results objectForKey:@"scene-title-y"] floatValue];
            [creditsConfig setTitlePosition:CGPointMake(titleX, titleY)];
            
            float panelX = [[results objectForKey:@"panel-title-x"] floatValue];
            float panelY = [[results objectForKey:@"panel-title-y"] floatValue];
            [creditsConfig setPanelPosition:CGPointMake(panelX, panelY)];

            float touchX = [[results objectForKey:@"touch-title-x"] floatValue];
            float touchY = [[results objectForKey:@"touch-title-y"] floatValue];
            [creditsConfig setTouchPosition:CGPointMake(touchX, touchY)];
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
}

- (void)loadPurchaseConfigWithWidth:(int)width andHeight:(int)height {
    
    // Load the raw data for this menu.
    NSData *data = [self loadDataForMenu:@"Purchase_Config" andWidth:width andHeight:height];
    
    // Create and store the stage menu container object.
    purchaseConfig = [[PurchaseConfig alloc] init];
    
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
            /* proceed with results as you like; the assignment to
             an explicit NSDictionary * is artificial step to get
             compile-time checking from here on down (and better autocompletion
             when editing). You could have just made object an NSDictionary *
             in the first place but stylistically you might prefer to keep
             the question of type open until it's confirmed */
            
            [purchaseConfig setSceneTitle:[results objectForKey:@"scene-title"]];
            [purchaseConfig setSceneImage:[results objectForKey:@"scene-image"]];
            [purchaseConfig setSceneMusic:[results objectForKey:@"scene-music"]];
            
            float titleX = [[results objectForKey:@"scene-title-x"] floatValue];
            float titleY = [[results objectForKey:@"scene-title-y"] floatValue];
            
            [purchaseConfig setTitlePosition:CGPointMake(titleX, titleY)];
            
            NSArray *buttons = [results objectForKey:@"buttons"];
            for(int i=0; i < [buttons count]; i++) {
                NSDictionary *icon = [buttons objectAtIndex:i];
                NSString *id = [icon objectForKey:@"id"];
                int x = (int)[[icon objectForKey:@"x"] integerValue];
                int y = (int)[[icon objectForKey:@"y"] integerValue];
                int w = (int)[[icon objectForKey:@"w"] integerValue];
                int h = (int)[[icon objectForKey:@"h"] integerValue];
                
                CGPoint position = CGPointMake(x, y);
                CGRect bounds = CGRectMake(x-(w/2), y-(h/2), w, h);
                
                UIFadeButton *button = [[UIFadeButton alloc] init];
                [button setID:id];
                [button setBounds:bounds];
                [button setPosition:position];
                [button setState:0];
                
                [[purchaseConfig buttons] addObject:button];
                
                [button release];
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
}



- (AudioConfig*)getAudioConfig {
    return audioConfig;
}

- (MenuConfig*)getMenuConfig {
    return menuConfig;
}

- (StageConfig*)getStageConfig {
    return stageConfig;
}

- (GameConfig*)getGameConfig {
    return gameConfig;
}

- (DailyConfig*)getDailyConfig {
    return dailyConfig;
}

- (ScoreConfig*)getScoreConfig {
    return scoreConfig;
}

- (CreditsConfig*)getCreditsConfig {
    return creditsConfig;
}

- (PurchaseConfig*)getPurchaseConfig {
    return purchaseConfig;
}

/*
- (void)dealloc {
    [super dealloc];
    [gameConfig release];
    [menuConfig release];
    [stageConfig release];
}
*/

@end
