//
//  ImageManager.h
//
//  Created by James Bishop on 6/24/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//
#import <Foundation/Foundation.h>

@class Image;

// Class that is responsible for texture resources witihn the game.  This class should be
// used to load any texture.  The class will check to see if an instance of that Texture
// already exists and will return a reference to it if it does.  If not instance already
// exists then it will create a new instance and pass a reference back to this new instance.
// The filename of the texture is used as the key within this class.
//
@interface ImageManager : NSObject {
    NSMutableDictionary *_cachedImages;
}

+ (ImageManager*)sharedImageManager;

- (void)addImageWithName:(NSString*)name andKey:(NSString*)key;
- (void)addImage:(Image*)image andKey:(NSString*)key;
- (Image*)getImageWithKey:(NSString*)key;
- (Image*)getImageWithName:(NSString*)name;
- (BOOL)releaseImageWithKey:(NSString*)name;
- (void)releaseAllImages;

@end
