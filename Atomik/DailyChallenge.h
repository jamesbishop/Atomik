//
//  DailyChallenge.h
//  Atomik
//
//  Created by James on 6/10/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DailyChallenge : NSObject {
    NSString *codekey;
    int stage;
    int level;
    int rank;
    int plays;
}

@property (nonatomic, retain) NSString *codekey;
@property (nonatomic, assign) int stage;
@property (nonatomic, assign) int level;
@property (nonatomic, assign) int rank;
@property (nonatomic, assign) int plays;

@end
