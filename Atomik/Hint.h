//
//  Hint.h
//  Atomik
//
//  Created by James on 12/16/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Hint : NSObject {
    NSString *text;
    float timer;
    CGPoint position;
}

@property (nonatomic, retain) NSString *text;
@property (nonatomic, assign) float timer;
@property (nonatomic, assign) CGPoint position;

@end
