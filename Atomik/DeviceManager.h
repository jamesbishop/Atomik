//
//  DeviceManager.h
//  Atomik
//
//  Created by James on 6/24/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

#define DOCUMENTS_FOLDER        @"Documents"

@interface DeviceManager : NSObject {
    // Local variables for this class.
}

+ (id)sharedDeviceManager;

- (NSString*)createNewUUID;

- (void)showDocumentsDirectory;
- (void)clearDocumentsDirectory;

- (BOOL)doesFileExist:(NSString*)filename;
- (BOOL)createFile:(NSString*)filename;
- (BOOL)deleteFile:(NSString*)filename;
- (void)writeStringToFile:(NSString*)filename content:(NSString*)content;
- (void)writeDataToFile:(NSString*)filename data:(NSData*)data;
- (NSString*)readStringFromFile:(NSString*)filename;
- (NSData*)readDataFromFile:(NSString*)filename;
    
@end

