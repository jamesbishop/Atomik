//
//  AudioControl.h
//  Atomik
//
//  Created by James on 3/15/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "AbstractControl.h"
#import "AudioConfig.h"

@interface AudioControl : AbstractControl {
    ConfigManager *_configManager;
    NSMutableArray *sliders;
    NSMutableArray *buttons;
    UIFadeButton *active;
}

@property (nonatomic, assign) NSMutableArray *sliders;
@property (nonatomic, assign) NSMutableArray *buttons;

- (void)reset;
- (UIFadeButton*)getActiveButton;

@end
