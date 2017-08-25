//
//  UILabel.h
//  Atomik
//
//  Created by James on 6/9/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UITextLabel : NSObject {
    NSString *text;
    CGPoint position;
    int align;
}

@property (nonatomic, assign) NSString *text;
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) int align;

- (id)initWithText:(NSString*)newText andPosition:(CGPoint)newPosition withAlignment:(int)newAlign;

@end
