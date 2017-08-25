//
//  ResourceManager.m
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//
#import "TextureManager.h"
#import "Common.h"
#import "SynthesizeSingleton.h"
#import "Texture2D.h"

@implementation TextureManager

SYNTHESIZE_SINGLETON_FOR_CLASS(TextureManager);

- (id)init {
	// Initialize a dictionary with an initial size to allocate some memory, 
    // but it will increase in size as necessary as it is mutable.
	_cachedTextures = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	
	return self;
}

- (void)addTextureWithName:(NSString*)name andKey:(NSString*)key {
    if([_cachedTextures objectForKey:key] != nil) {
        [_cachedTextures removeObjectForKey:key];
    }

    Texture2D *texture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:name] filter:GL_NEAREST];
    [_cachedTextures setObject:texture forKey:key];
    [texture release];
}

- (Texture2D*)getTextureWithKey:(NSString*)key {
    return [[_cachedTextures objectForKey:key] autorelease];
}

- (Texture2D*)getTextureWithName:(NSString*)name {
    // Try to get a texture from cachedTextures with the supplied key.
    Texture2D *_cachedTexture = [_cachedTextures objectForKey:name];
    
    // If we can find a texture with the supplied key then return it.
    if(_cachedTexture != nil) {
        return _cachedTexture;
    }
    
    // As no texture was found we create a new one, cache it and return it.
    _cachedTexture = [[Texture2D alloc] initWithImage:[UIImage imageNamed:name] filter:GL_NEAREST];
    [_cachedTextures setObject:_cachedTexture forKey:name];
    
    // Return the texture which is autoreleased as the caller is responsible for it
    return [_cachedTexture autorelease];
}

- (BOOL)releaseTextureWithKey:(NSString*)key {
    // Try to get a texture from cachedTextures with the supplied key.
    Texture2D *cachedTexture = [_cachedTextures objectForKey:key];
    
    // If a texture was found we can remove it from the cachedTextures and return YES.
    if(cachedTexture) {
        [_cachedTextures removeObjectForKey:key];
        return YES;
    }
    
    // No texture was found with the supplied key so log that and return NO;
    return NO;
}

- (void)releaseAllTextures {
    [_cachedTextures removeAllObjects];
}

- (void)dealloc {
    // Release the cachedTextures dictionary.
	[_cachedTextures release];
	[super dealloc];
}


@end
