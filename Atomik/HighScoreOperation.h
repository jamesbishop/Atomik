//
//  NetworkScore.h
//  Atomik
//
//  Created by James on 10/22/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayerScore.h"

@interface HighScoreOperation : NSOperation<NSURLConnectionDelegate> {
    NSMutableData *responseData;
    NSURLConnection *urlConnection;
    
    NSURL *serverURL;
    NSString *serverData;
    PlayerScore *score;
    
    BOOL executing;
    BOOL finished;
}

@property (nonatomic, retain) NSURL *serverURL;
@property (nonatomic, retain) NSString *serverData;
@property (nonatomic, retain) PlayerScore *score;

@end
