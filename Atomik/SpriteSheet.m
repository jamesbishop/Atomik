//
//  SpriteSheet.m
//
//  Created by James Bishop on 21/12/2011.
//  Copyright 2011 Black Cell. All rights reserved.
//

#import "SpriteSheet.h"

// Private methods
@interface SpriteSheet ()
// Private selector that is used as a standard method for initializing a sprite sheet
- (void)initImplementation:(GLuint)aSpriteWidth spriteHeight:(GLuint)aSpriteHeight spacing:(GLuint)aSpacing imageScale:(float)scale;

// Precalculate texture coordinates for all the sprites on the sprite sheet
- (void)calculateCachedTextureCoordinates;
@end

@implementation SpriteSheet

@synthesize spriteSheetName;
@synthesize spriteImage;
@synthesize spriteWidth;
@synthesize spriteHeight;
@synthesize spacing;
@synthesize scale;
@synthesize horizontal;
@synthesize vertical;

- (id)init {
	self = [super init];
	if (self != nil) {
		spriteImage = nil;
		spriteWidth = 0;
		spriteHeight = 0;
		spacing = 0;
		scale = 1.0f;
	}
	return self;
}

- (id)initWithImage:(Image*)aSpriteSheet spriteWidth:(GLuint)aSpriteWidth spriteHeight:(GLuint)aSpriteHeight spacing:(GLuint)aSpacing {
    
	self = [super init];
	if (self != nil) {		
		// This spritesheet will use the image passed in as the spritesheet source
		spriteImage = aSpriteSheet;
        
		// Up the retain count for the image as its defined outside of this class and we don't want 
		// a release outside this class to remove it before we are finished with it
		[spriteImage retain];
		
		// Call the standard init implementation		
		[self initImplementation:aSpriteWidth spriteHeight:aSpriteHeight spacing:aSpacing imageScale:[spriteImage scale]];
	}
	return self;
}

- (id)initWithImageNamed:(NSString*)aImageName spriteWidth:(GLuint)aSpriteWidth spriteHeight:(GLuint)aSpriteHeight spacing:(GLuint)aSpacing imageScale:(float)theScale {
    
	self = [super init];
	if (self != nil) {
		// Set the sprite sheet name
		spriteSheetName = aImageName;
		
		// Create a new image from the filename provided which will be used as the sprite sheet
		spriteImage = [[Image alloc] initWithImage:aImageName scale:theScale];

		// Call the standard init implementation
		[self initImplementation:aSpriteWidth spriteHeight:aSpriteHeight spacing:aSpacing imageScale:theScale];
	}
	return self;
}

- (void)initImplementation:(GLuint)aSpriteWidth spriteHeight:(GLuint)aSpriteHeight spacing:(GLuint)aSpacing imageScale:(float)theScale {
    
	// Set the width, height and spacing within the spritesheet
	spriteWidth = aSpriteWidth;
	spriteHeight = aSpriteHeight;
	spacing = aSpacing;
	horizontal = (([spriteImage imageWidth] - spriteWidth) / (spriteWidth + spacing)) + 1;
	vertical =  (([spriteImage imageHeight] - spriteHeight) / (spriteHeight + spacing)) + 1;
	if(([spriteImage imageHeight] - spriteHeight) % (spriteHeight + spacing) != 0) {
		vertical++;
	}
    
    // Allocate the memory needed for the texture coordinates array
    cachedTextureCoordinates = calloc((horizontal*vertical), sizeof(Quad2f));
    
    // Calculate the texture coordinates for all the sprites in this spritesheet
    [self calculateCachedTextureCoordinates];
}

- (Image*)getSpriteAtX:(GLuint)x y:(GLuint)y {	
    
	//Calculate the point from which the sprite should be taken within the spritesheet
	CGPoint spritePoint = [self getOffsetForSpriteAtX:x y:y];

	// Return the subimage defined by the point and dimensions of a sprite.  This will use the spritesheet
	// images scale so that it is respected in the image returned
	return [[spriteImage getSubImageAtPoint:spritePoint subImageWidth:spriteWidth subImageHeight:spriteHeight scale:[spriteImage scale]] retain];
}

- (void)renderSpriteAtX:(GLuint)x y:(GLuint)y point:(CGPoint)aPoint centerOfImage:(BOOL)aCenter {
	//Calculate the point from which the sprite should be taken within the spritesheet
	CGPoint spritePoint = [self getOffsetForSpriteAtX:x y:y];
	
	// Rather than return a new image for this sprite we are going to just render the specified
	// sprite at the specified location
	[spriteImage renderSubImageAtPoint:aPoint offset:spritePoint subImageWidth:spriteWidth subImageHeight:spriteHeight centerOfImage:aCenter];
}

- (Quad2f)getTextureCoordsForSpriteAtX:(GLuint)x y:(GLuint)y {

    // Calculate the location within the texture coordinates array based on the 
    // x and y location provided
    int index = (y * horizontal + x);
    
    // Check to make sure the coordinates are within range else raise an error
    if(index > (horizontal * vertical)) {
        NSLog(@"ERROR - SpriteSheet: texture location out of range.");
    }    
    
    // Return the coordinates at the specified location
	return cachedTextureCoordinates[index];
}

- (void)calculateCachedTextureCoordinates {    
    //NSLog(@"Sprite Name: %@", spriteSheetName);
    
    // Loop through the rows and columns of the spritsheet calculating the texture coordinates
    // These coordinates are stored and returned when required to help performance
    int spriteSheetCount = 0;
    for(int row=0; row < vertical; row++) {
        for(int col=0; col < horizontal; col++) {
            
            CGPoint spritePoint = [self getOffsetForSpriteAtX:col y:row];
           	[spriteImage calculateTexCoordsAtOffset:spritePoint subImageWidth:spriteWidth subImageHeight:spriteHeight];
            Quad2f t = *[spriteImage textureCoordinates];
            
            //NSLog(@"- Calculate: Point(%.f, %.f), Width: %d, Height: %d", spritePoint.x, spritePoint.y, spriteWidth, spriteHeight);
            //NSLog(@"- Quads(XY): (%.2f, %.2f),(%.2f, %.2f),(%.2f, %.2f),(%.2f, %.2f)", t.tl_x,t.tl_y, t.tr_x,t.tr_y, t.bl_x,t.bl_y, t.br_x,t.br_y);
            cachedTextureCoordinates[spriteSheetCount] = t;
            spriteSheetCount++;
        }
    }
}

- (Quad2f*)getVerticesForSpriteAtX:(GLuint)x y:(GLuint)y point:(CGPoint)aPoint centerOfImage:(BOOL)aCenter {
	[spriteImage calculateVerticesAtPoint:aPoint subImageWidth:spriteWidth subImageHeight:spriteHeight centerOfImage:aCenter];
	return [spriteImage vertices];
}

- (CGPoint)getOffsetForSpriteAtX:(int)x y:(int)y {
	return CGPointMake(x * (spriteWidth + spacing), y * (spriteHeight + spacing));	
}

- (void)dealloc {
    // Release the image.  If the image was allocated within this class using initWithImageNamed then that
	// image will be released.  If not and initWithImage was used, then this will reduce the count on
	// the image so it could be released outside of this class
	[spriteImage release];
    free(cachedTextureCoordinates);
	[super dealloc];
}

@end
