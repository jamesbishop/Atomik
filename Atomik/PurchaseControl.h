//
//  PurchaseControl.h
//  Atomik
//
//  Created by James on 2/9/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "AbstractControl.h"

@interface PurchaseControl : AbstractControl {
    ConfigManager *_configManager;
    UIFadeButton *active;   
}

- (void)reset;
- (UIFadeButton*)getActiveButton;

@end
