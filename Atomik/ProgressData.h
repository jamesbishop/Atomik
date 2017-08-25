//
//  ProgressData.h
//  Atomik
//
//  Created by James on 2/1/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProgressData : NSObject {
    NSString *deviceID;
    NSString *platform;
    NSString *version;
    float musicVolume;
    float effectsVolume;
}

@property (nonatomic, retain) NSString *deviceID;
@property (nonatomic, retain) NSString *platform;
@property (nonatomic, retain) NSString *version;
@property (nonatomic, assign) float musicVolume;
@property (nonatomic, assign) float effectsVolume;

- (NSDictionary*)content;

@end
