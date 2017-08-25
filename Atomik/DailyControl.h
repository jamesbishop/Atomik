//
//  DailyControl.h
//  Atomik
//
//  Created by James on 6/10/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "AbstractControl.h"

@interface DailyControl : AbstractControl {
    ConfigManager *_configManager;
    UIFadeButton *active;
}

- (void)reset;
- (UIFadeButton*)getActiveButton;

@end
