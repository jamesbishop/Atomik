//
//  ServerHeader.h
//  Atomik
//
//  Created by James on 10/22/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerHeader : NSObject {
    NSString *version;
    NSString *system;
    NSString *clock;
    NSString *device;
    NSString *token;
}

@property (nonatomic, retain) NSString *version;
@property (nonatomic, retain) NSString *system;
@property (nonatomic, retain) NSString *clock;
@property (nonatomic, retain) NSString *device;
@property (nonatomic, retain) NSString *token;

@end
