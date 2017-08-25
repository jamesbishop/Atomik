//
//  TextureManager.h
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import <Foundation/Foundation.h>

@class Texture2D;

// Class that is responsible for texture resources witihn the game.  This class should be
// used to load any texture.  The class will check to see if an instance of that Texture
// already exists and will return a reference to it if it does.  If not instance already
// exists then it will create a new instance and pass a reference back to this new instance.
// The filename of the texture is used as the key within this class.
//
@interface TextureManager : NSObject {
    NSMutableDictionary     *_cachedTextures;
}

+ (TextureManager*)sharedTextureManager;

- (void)addTextureWithName:(NSString*)name andKey:(NSString*)key;
- (Texture2D*)getTextureWithKey:(NSString*)key;
- (Texture2D*)getTextureWithName:(NSString*)name;
- (BOOL)releaseTextureWithKey:(NSString*)key;
- (void)releaseAllTextures;

@end
