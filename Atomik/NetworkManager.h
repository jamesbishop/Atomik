//
//  NetworkManager.h
//  Atomik
//
//  Created by James Bishop on 6/5/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonCrypto.h>

#import "Base64.h"
#import "DeviceManager.h"
#import "ProgressManager.h"
#import "ProgressData.h"
#import "PlayerScore.h"
#import "DailyChallenge.h"
#import "HighScoreOperation.h"
#import "DailyScoreOperation.h"

#define MASTER_SERVER   @"http://www.atomik.mobi/server"
#define SERVER_VERSION  @"v1.0.0"

#define PRIVATE_KEY     @"secret"

@interface NetworkManager : NSObject {
    
}

+ (id)sharedNetworkManager;

- (void)submitScoreToServer:(PlayerScore*)score;
- (void)submitDailyToServer:(PlayerScore*)score forChallenge:(DailyChallenge*)challenge;

- (DailyChallenge*)loadDailyChallenge:(ProgressData*)progress;

@end
