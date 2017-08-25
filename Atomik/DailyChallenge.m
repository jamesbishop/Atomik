//
//  DailyChallenge.m
//  Atomik
//
//  Created by James on 6/10/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "DailyChallenge.h"

@implementation DailyChallenge

@synthesize codekey;
@synthesize stage;
@synthesize level;
@synthesize rank;
@synthesize plays;

- (id)init {
    if(self = [super init]) {
        // Do nothing.
    }
    return self;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"Challenge: Codekey=%@, Stage=%d, Level=%d, Rank=%d, Plays=%d", codekey, stage, level, rank, plays];
}

- (void)dealloc {
    [super dealloc];
    [codekey release];
}
@end
