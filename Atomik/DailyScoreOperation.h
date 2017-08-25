//
//  DailyScoreOperation.h
//  Atomik
//
//  Created by James on 6/9/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerScore.h"
#import "DailyChallenge.h"

@interface DailyScoreOperation : NSOperation<NSURLConnectionDelegate> {
    NSMutableData *responseData;
    NSURLConnection *urlConnection;
    
    NSURL *serverURL;
    NSString *serverData;
    DailyChallenge *challenge;
    PlayerScore *score;
    
    BOOL executing;
    BOOL finished;
}

@property (nonatomic, retain) NSURL *serverURL;
@property (nonatomic, retain) NSString *serverData;
@property (nonatomic, retain) DailyChallenge *challenge;
@property (nonatomic, retain) PlayerScore *score;

@end