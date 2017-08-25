//
//  MenuControl.h
//
//  Created by James Bishop on 12/17/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "AbstractControl.h"

@interface MenuControl : AbstractControl {
    ConfigManager *_configManager;
    UIFadeButton *active;
}

- (void)reset;
- (UIFadeButton*)getActiveButton;

@end
