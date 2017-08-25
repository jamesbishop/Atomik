//
//  MenuButton.h
//  Atomik
//
//  Created by James on 11/21/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Image.h"

@interface UIFadeButton : NSObject {
    NSString *ID;
    CGRect bounds;
    CGPoint position;
    int state;
}

@property (nonatomic, retain) NSString *ID;
@property (nonatomic, assign) CGRect bounds;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) int state;

- (void)reset;
- (void)update:(float)delta;
- (void)render;
    
@end
