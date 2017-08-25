//
//  NetworkScore.m
//  Atomik
//
//  Created by James on 10/22/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "HighScoreOperation.h"

@interface HighScoreOperation (Private)
- (void)run;
@end

@implementation HighScoreOperation

@synthesize serverURL;
@synthesize serverData;
@synthesize score;

- (id)init {
    if (self = [super init]) {
        // Perform all the constructor tasks.
        responseData = [[NSMutableData alloc] init];
        
    }
    return self;
}

- (void)start {
    //NSLog(@"- HighScoreOperation:start (URL: %@) ...", [serverURL description]);
    
    // Fix for iOS 4.0
    if(![NSThread isMainThread]) {
        //NSLog(@"Fix for iOS 4.0!");
        [self performSelectorOnMainThread:@selector(start) withObject:nil waitUntilDone:NO];
        return;
    }
    
    if(finished || [self isCancelled]) {
        [self done];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    executing = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
#ifdef LITE_VERSION
    BOOL isLite = YES;
#else
    BOOL isLite = NO;
#endif
    
    // Do the main work of the operation implementation here.
    // Replace the default JSON server data with our score data.
    NSString *jsonRequest = [NSString stringWithFormat:serverData, [[score header] version], [[score header] system],
            [[score header] clock], [[score header] device], [[score header] token], [score width], [score height],
            [score retina] ? 1 : 0, (isLite ? 1 : 0), [score stage], [score level], [score molecules], [score success],
            [score failure], [score missed], [score collisions], [score duration], [score score], [score target],
            [score percentage], [score livesAllowed], [score livesRemaining], [score progress]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:serverURL
            cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    NSData *requestData = [NSData dataWithBytes:[jsonRequest UTF8String] length:[jsonRequest length]];
    
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setValue:[NSString stringWithFormat:@"%lu",(unsigned long)[requestData length]] forHTTPHeaderField:@"Content-Length"];
    [request setHTTPBody:requestData];
    
    urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (BOOL)isConcurrent {
    return YES;
}

- (BOOL)isExecuting {
    return executing;
}

- (BOOL)isFinished {
    return finished;
}

- (void)done {
    if(responseData) {
        [responseData release];
    }
    if(urlConnection) {
        [urlConnection release];
    }
    responseData = nil;
    urlConnection = nil;
    
    finished = YES;
    executing = NO;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    //NSLog(@"- HighScoreOperation:connection:didReceiveResponse");
    
    [responseData setLength:0];
    //NSLog(@"  DESCRIPTION: %@\n", response.description);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    //NSLog(@"- HighScoreOperation:connection:didReceiveData:%lu bytes", (unsigned long)[data length]);
    [responseData appendData:data];
}

- (NSCachedURLResponse*)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    //NSLog(@"- HighScoreOperation:connection:willCacheResponse");
    
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    // The request is complete and data has been received
    // You can parse the stuff in your instance variable now
    //NSLog(@"- HighScoreOperation:connectionDidFinishLoading");
    
    //NSLog(@"  Succeeded! Received %lu bytes of data",(unsigned long)[responseData length]);
    //NSString *str = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
    //NSLog(@"  DATA: %@", str);
    
    [connection release];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    // The request has failed for some reason!
    // Check the error var
    //NSLog(@"- HighScoreOperation:connection:didFailWithError");
    
    //NSLog(@"  ERROR: %@\n", error.description);
}

@end
