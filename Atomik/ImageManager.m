//
//  ImageManager.m
//
//  Created by James Bishop on 6/24/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//
#import "ImageManager.h"
#import "Common.h"
#import "SynthesizeSingleton.h"
#import "Image.h"

@implementation ImageManager

SYNTHESIZE_SINGLETON_FOR_CLASS(ImageManager);

- (id)init {
	// Initialize a dictionary with an initial size to allocate some memory,  
    // but it will increase in size as necessary as it is mutable.
    _cachedImages = [[NSMutableDictionary dictionaryWithCapacity:10] retain];
	
	return self;
}

- (void)addImageWithName:(NSString*)name andKey:(NSString*)key {
    if([_cachedImages objectForKey:key] != nil) {
        [_cachedImages removeObjectForKey:key];
    }
    
    Image *image = [(Image*)[Image alloc] initWithImage:name scale:1.0f filter:GL_NEAREST];
    [_cachedImages setObject:image forKey:key];
    [image release];
    
    //NSLog(@"ImageManager -> (Name: %@, Key: %@) added ... %d", name, key, [_cachedImages count]);
}

- (void)addImage:(Image *)image andKey:(NSString *)key {
    if([_cachedImages objectForKey:key] != nil) {
        [_cachedImages removeObjectForKey:key];
    }
    
    [_cachedImages setObject:image forKey:key];
}

- (Image*)getImageWithKey:(NSString*)key {
    return [_cachedImages objectForKey:key];
}

- (Image*)getImageWithName:(NSString*)name {
    Image *_cachedImage = [_cachedImages objectForKey:name];
    
    // If we can find a texture with the supplied key then return it.
    if(_cachedImage != nil) {
        return _cachedImage;
    }
    
    // As no texture was found we create a new one, cache it and return it.
    _cachedImage = [[Image alloc] initWithImage:name scale:1.0f filter:GL_NEAREST];
    [_cachedImages setObject:_cachedImage forKey:name];
    
    // Return the texture which is autoreleased as the caller is responsible for it
    return [_cachedImage autorelease];
}

- (BOOL)releaseImageWithKey:(NSString*)key {
    // Try to get a texture from cachedTextures with the supplied key.
    Image *cachedImage = [_cachedImages objectForKey:key];
    
    // If a texture was found we can remove it from the cachedTextures and return YES.
    if(cachedImage) {
        [_cachedImages removeObjectForKey:key];
        return YES;
    }
    
    // No texture was found with the supplied key so log that and return NO;
    return NO;
}

- (void)releaseAllImages {
    [_cachedImages removeAllObjects];
}

- (void)dealloc {
    // Release the cachedTextures dictionary.
    [_cachedImages release];
	[super dealloc];
}


@end
