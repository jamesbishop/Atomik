//
//  UIHelper.h
//  Atomik
//
//  Created by James on 3/15/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "Font.h"

@interface UIHelper : NSObject {
    
}

+ (NSString*)formatPercentageFromDecimal:(float)decimal;
+ (NSString*)formatNumberWithCommas:(int)number;
+ (NSString*)formatTimeFromSeconds:(int)duration;
+ (NSString*)formatLivesRemaining:(int)remaining withAllowed:(int)allowed;

+ (NSInteger)randomNumberBetweenMinimum:(int)minimum andMaximum:(int)maximum;

+ (void)leftText:(NSString*)text withFont:(Font*)font atLocation:(CGPoint)location;
+ (void)centreText:(NSString*)text withFont:(Font*)font atLocation:(CGPoint)location;
+ (void)rightText:(NSString*)text withFont:(Font*)font atLocation:(CGPoint)location;

@end
