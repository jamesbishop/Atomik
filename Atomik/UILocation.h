//
//  UILocation.h
//  Atomik
//
//  Created by James on 3/22/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UILocation : NSObject {
    CGPoint location;
}

@property (nonatomic, assign) CGPoint location;
    
- (id)initWithLocation:(CGPoint)location;
    
@end
