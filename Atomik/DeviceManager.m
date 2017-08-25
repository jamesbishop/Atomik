//
//  DeviceManager.m
//
//  Created by James on 6/24/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "DeviceManager.h"
#import "SynthesizeSingleton.h"


@interface DeviceManager (Private)
    
// Standard file handling procedures
- (NSString*)findDocumentsDirectory;
- (NSString*)findDocumentsFile:(NSString*)filename;
    
@end

@implementation DeviceManager

SYNTHESIZE_SINGLETON_FOR_CLASS(DeviceManager);

- (id)init {
    if (self = [super init]) {
        // Initialisation stuff goes here.
    }
    return self;
}

- (NSString*)createNewUUID {
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString*)string autorelease];
    
    //NSString *device  =  [NSString stringWithFormat:@"%@", [[[UIDevice currentDevice] identifierForVendor] UUIDString]];
}

- (NSString*)findDocumentsDirectory {
    return [NSHomeDirectory() stringByAppendingPathComponent:DOCUMENTS_FOLDER];
}
    
- (NSString*)findDocumentsFile:(NSString*)filename {
    return [[self findDocumentsDirectory] stringByAppendingPathComponent:filename];
}
    
- (void)showDocumentsDirectory {
    //NSString *documentsDirectory = [self findDocumentsDirectory];
    
    //NSFileManager *fileManager = [NSFileManager defaultManager];
    //NSLog(@"Documents (%@): %@", documentsDirectory, [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil]);
}
    
- (void)clearDocumentsDirectory {
    //NSLog(@"===== CLEAR DOCUMENTS DIRECTORY =====");
    
    NSString *documentsDirectory = [self findDocumentsDirectory];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:nil];
    
    for(NSString *fileToDelete in contents) {
        //NSLog(@"Deleting: %@", fileToDelete);
        [self deleteFile:fileToDelete];
    }
    
    //NSLog(@"=====================================");
}

- (BOOL)doesFileExist:(NSString*)filename {
    NSString *filepath = [self findDocumentsFile:filename];
        
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL fileExists = [fileManager fileExistsAtPath:filepath];
        
    return fileExists;
}
    
- (BOOL)createFile:(NSString*)filename {
    // File we want to create in the documents directory
    // Result is: /Documents/created-new-filename.txt
    NSString *filePath = [self findDocumentsFile:filename];
    
    // We just want to create the file, so empty content.
    NSString *content = @"";
    
    // Write content directory to the file path created.
    return [content writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
    
- (BOOL)deleteFile:(NSString*)filename {
    NSString *filepath = [self findDocumentsFile:filename];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    return [fileManager removeItemAtPath:filepath error:nil];
}
    
- (void)writeStringToFile:(NSString*)filename content:(NSString*)content {
    NSString *filepath = [self findDocumentsFile:filename];
    [content writeToFile:filepath atomically:YES encoding:NSUTF8StringEncoding error:nil];
}
    
- (void)writeDataToFile:(NSString*)filename data:(NSData*)data {
    NSString *dataToString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    [self writeStringToFile:filename content:dataToString];
    [dataToString release];
}
    
- (NSString*)readStringFromFile:(NSString*)filename {
    NSString *fullpath = [self findDocumentsFile:filename];
    return [NSString stringWithContentsOfFile:fullpath encoding:NSUTF8StringEncoding error:nil];
}
    
- (NSData*)readDataFromFile:(NSString*)filename {
    NSString *filepath = [self findDocumentsFile:filename];
    return [NSData dataWithContentsOfFile:filepath options:NSUTF8StringEncoding error:nil];
}

@end
