//
//  StageControl.h
//  Atomik
//
//  Created by James on 11/10/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "AbstractControl.h"

@interface StageControl : AbstractControl {
    ConfigManager *_configManager;
    UIFadeButton *active;
}

- (void)reset;
- (UIFadeButton*)getActiveButton;

@end
