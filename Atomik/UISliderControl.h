//
//  UISlider.h
//  Atomik
//
//  Created by James on 3/21/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UILocation.h"
#import "Image.h"

@interface UISliderControl : NSObject {
    CGPoint position;
    int minimum;
    int maximum;
    float value;

    NSString *_name;
    CGPoint _slider;
    CGRect  _bounds;
    CGSize  _size;
    Image *_guage;
    Image *_inactive;
    Image *_active;
    int _state;
    
    float _distance;
    float _upperY;
    float _lowerY;
    
    CGPoint titleText;
    CGPoint volumeText;
}
    
@property (nonatomic, assign) CGPoint position;
@property (nonatomic, assign) float value;
@property (nonatomic, assign) int minimum;
@property (nonatomic, assign) int maximum;
@property (nonatomic, assign) CGPoint titleText;
@property (nonatomic, assign) CGPoint volumeText;

- (id)initWithName:(NSString*)name withSize:(CGSize)size atPosition:(CGPoint)position;
    
- (void)update:(float)delta;
- (void)render;

- (void)touchBegan:(UILocation*)location;
- (void)touchMoved:(UILocation*)location;
- (void)touchEnded:(UILocation*)location;
- (void)touchCancel:(UILocation*)location;

@end
