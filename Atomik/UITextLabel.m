//
//  UILabel.m
//  Atomik
//
//  Created by James on 6/9/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "UITextLabel.h"

@implementation UITextLabel

@synthesize text;
@synthesize position;
@synthesize align;

- (void)dealloc {
    [super dealloc];
}

- (id)initWithText:(NSString*)newText andPosition:(CGPoint)newPosition withAlignment:(int)newAlign {
    if(self = [super init]) {
        text = newText;
        position = newPosition;
        align = newAlign;
    }
    return self;
}

@end
