//
//  UIHelper.m
//  Atomik
//
//  Created by James on 3/15/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper

+ (NSString*)formatPercentageFromDecimal:(float)decimal {
    float percentage = (decimal * 100.0f);
    return [NSString stringWithFormat:@"%.f%%", percentage];
}
   
+ (NSString*)formatNumberWithCommas:(int)number {
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterNoStyle];
    [formatter setMaximumFractionDigits:0];
    
    NSString *groupingSeparator = [[NSLocale currentLocale] objectForKey:NSLocaleGroupingSeparator];
    [formatter setGroupingSeparator:groupingSeparator];
    [formatter setGroupingSize:3];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:YES];
    
    NSString *score = [formatter stringFromNumber:[NSNumber numberWithInt:number]];
    
    [formatter release];
    
    return score;
}
    
+ (NSString*)formatTimeFromSeconds:(int)duration {
    int seconds = duration;
    
    int days = seconds / (60 * 60 * 24);
    seconds -= days * (60 * 60 * 24);
    
    int hours = seconds / (60 * 60);
    seconds -= hours * (60 * 60);
    
    int mins = seconds / 60;
    seconds -= mins * 60;
    
    // We do not need hours in the timer display formet.
    //return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, mins, seconds];
    
    return [NSString stringWithFormat:@"%02d:%02d", mins, seconds];
}
  
+ (NSString*)formatLivesRemaining:(int)remaining withAllowed:(int)allowed {
    return [NSString stringWithFormat:@"%d / %d", remaining, allowed];
}

+ (NSInteger)randomNumberBetweenMinimum:(int)minimum andMaximum:(int)maximum {
    return minimum + (arc4random() % (maximum - minimum + 1));
}

+ (void)leftText:(NSString*)text withFont:(Font*)font atLocation:(CGPoint)location {
    [font drawStringAt:location text:text];
}

+ (void)centreText:(NSString*)text withFont:(Font*)font atLocation:(CGPoint)location {
    float x = (location.x - ([font getWidthForString:text] / 2.0f));
    [font drawStringAt:CGPointMake(x, location.y) text:text];
}

+ (void)rightText:(NSString*)text withFont:(Font*)font atLocation:(CGPoint)location {
    float x = (location.x - [font getWidthForString:text]);
    [font drawStringAt:CGPointMake(x, location.y) text:text];
}

@end
