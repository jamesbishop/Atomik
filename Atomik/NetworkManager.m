//
//  NetworkManager.m
//  Atomik
//
//  Created by James on 6/5/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "NetworkManager.h"
#import "SynthesizeSingleton.h"

@interface NetworkManager (Private)
- (NSData*)loadDataForService:(NSString*)service;
- (NSString*)performDataHash:(NSString*)data withKey:(NSString*)key;
- (ServerHeader*)createServerHeader;
- (NSURL*)findURLForService:(NSString*)service;
- (NSURL*)findURLForService:(NSString*)service withParams:(NSString*)params;
@end

@implementation NetworkManager

SYNTHESIZE_SINGLETON_FOR_CLASS(NetworkManager);

- (id)init {
    if (self = [super init]) {
        // Perform all the constructor tasks.
        //NSLog(@"Initialising NetworkManager ...");
    }
    return self;
}

- (NSData*)loadDataForService:(NSString*)service {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:service ofType:@"json"];
    return [NSData dataWithContentsOfFile:filePath];
}

- (NSString*)performDataHash:(NSString*)data withKey:(NSString*)key {
    NSData *secretData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData *stringData = [data dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableData *signature = [NSMutableData dataWithLength:CC_SHA1_DIGEST_LENGTH];
    
    CCHmac(kCCHmacAlgSHA1, secretData.bytes, secretData.length, stringData.bytes, stringData.length, signature.mutableBytes);
    
    NSMutableString *formatted = [NSMutableString stringWithString:[signature description]];
    
    [formatted replaceOccurrencesOfString:@"<" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [formatted length])];
    [formatted replaceOccurrencesOfString:@">" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [formatted length])];
    [formatted replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [formatted length])];
    
    return formatted;
}

- (ServerHeader*)createServerHeader {
    ProgressManager *_progressManager = [ProgressManager sharedProgressManager];
    
    NSString *clock =  [NSString stringWithFormat:@"%.0f", [[NSDate date] timeIntervalSince1970]];
    NSString *device = [[_progressManager getProgressData] deviceID];
    
    NSString *source = [NSString stringWithFormat:@"%@:%@:%@", clock, device, PRIVATE_KEY];
    NSString *hashed = [self performDataHash:source withKey:PRIVATE_KEY];
    NSString *encode = [hashed base64EncodedString];

    ServerHeader *header = [[ServerHeader alloc] init];
    [header setVersion:SERVER_VERSION];
    [header setSystem:[[UIDevice currentDevice] systemVersion]];
    [header setClock:clock];
    [header setDevice:device];
    [header setToken:encode];
    
    return header;
}

- (NSURL*)findURLForService:(NSString*)service {
    NSString *serverURL = [NSString stringWithFormat:@"%@/%@/%@.php", MASTER_SERVER, SERVER_VERSION, service];
    return [NSURL URLWithString:serverURL];
}

- (NSURL*)findURLForService:(NSString*)service withParams:(NSString*)params {
    NSString *serverURL = [NSString stringWithFormat:@"%@/%@/%@.php?%@", MASTER_SERVER, SERVER_VERSION, service, params];
    //NSLog(@"Server: %@", serverURL);
    
    return [NSURL URLWithString:serverURL];
}

- (void)submitScoreToServer:(PlayerScore*)score {
    //NSLog(@"NetworkManager:submitScoreToServer -> START ...");
    
    NSString *service = @"submit-score";
    NSURL *serverURL = [self findURLForService:service];
    NSData *jsonData = [self loadDataForService:service];
    
    NSString *serverData = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    
    ServerHeader *header = [self createServerHeader];
    [score setHeader:header];

    //NSLog(@"POST Data: [%@]", serverData);
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"SubmitScore Queue";
    queue.maxConcurrentOperationCount = 1;
    
    HighScoreOperation *operation = [[HighScoreOperation alloc] init];
    [operation setServerURL:serverURL];
    [operation setServerData:serverData];
    [operation setScore:score];
    
    [queue addOperation:operation];
    
    [operation release];
    
    [header release];
    
    [queue release];

    //NSLog(@"NetworkManager:submitScoreToServer -> DONE!");
}

- (void)submitDailyToServer:(PlayerScore*)score forChallenge:(DailyChallenge *)challenge {
    //NSLog(@"NetworkManager:submitDailyToServer -> START ...");
    
    NSString *service = @"submit-daily";
    NSURL *serverURL = [self findURLForService:service];
    NSData *jsonData = [self loadDataForService:service];
    
    NSString *serverData = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] autorelease];
    
    ServerHeader *header = [self createServerHeader];
    [score setHeader:header];
    
    //NSLog(@"POST Data: [%@]", serverData);
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    queue.name = @"SubmitDaily Queue";
    queue.maxConcurrentOperationCount = 1;
    
    DailyScoreOperation *operation = [[DailyScoreOperation alloc] init];
    [operation setServerURL:serverURL];
    [operation setChallenge:challenge];
    [operation setServerData:serverData];
    [operation setScore:score];
    
    [queue addOperation:operation];
    
    [operation release];
    
    [header release];
    
    [queue release];
    
    //NSLog(@"NetworkManager:submitDailyToServer -> DONE!");
}

- (DailyChallenge*)loadDailyChallenge:(ProgressData*)progress {
    //NSLog(@"NetworkManager:loadDailyChallenge -> START ...");
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"dd-MM-yyyy"];
    NSString *todaysDate = [formatter stringFromDate:[NSDate date]];
    [formatter release];
    
#ifdef LITE_VERSION
    int type = 1;
#else
    int type = 0;
#endif
    
    NSString *service = @"daily-challenge";
    NSString *params = [NSString stringWithFormat:@"device=%@&type=%d&date=%@", [progress deviceID], type, todaysDate];
    
    NSURL *serverURL = [self findURLForService:service withParams:params];
    
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:serverURL];

    // TODO: Possibly use an asynchronous service cll here?
    NSData *theData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:theData options:0 error:nil];
    
    [request release];
    
    DailyChallenge *challenge = [[DailyChallenge alloc] init];
    [challenge setCodekey:[json objectForKey:@"codekey"]];
    [challenge setStage:[[json objectForKey:@"stage"] integerValue]];
    [challenge setLevel:[[json objectForKey:@"level"] integerValue]];
    [challenge setRank:[[json objectForKey:@"rank"] integerValue]];
    [challenge setPlays:[[json objectForKey:@"plays"] integerValue]];
    
    //NSLog(@"Response (JSON): %@", json);
    
    //NSLog(@"NetworkManager:loadDailyChallenge -> DONE!");
    
    return challenge;
}

/*
- (void)dealloc {
    [super dealloc];
}
*/

@end
