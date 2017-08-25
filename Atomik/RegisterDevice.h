//
//  RegisterDevice.h
//  Atomik
//
//  Created by James on 4/16/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerHeader.h"

@interface RegisterDevice : NSObject {
    ServerHeader *header;
    int width;
    int height;
    BOOL retina;
    BOOL lite;
}

@end
