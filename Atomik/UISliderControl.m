//
//  UISlider.m
//  Atomik
//
//  Created by James on 3/21/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "UISliderControl.h"

@interface UISliderControl (Private)
- (void)calculate;
- (void)touchUpdate:(UILocation*)location;
@end

@implementation UISliderControl
    
@synthesize position;
@synthesize value;
@synthesize minimum;
@synthesize maximum;
@synthesize titleText;
@synthesize volumeText;

- (void)dealloc {
    [super dealloc];
    [_guage release];
    [_inactive release];
    [_active release];
}
    
- (id)initWithName:(NSString *)newName withSize:(CGSize)newSize atPosition:(CGPoint)newPosition {
    if (self = [super init]) {
        position = newPosition;
        
        _name = newName;
        _size = newSize;
        _slider = newPosition;
        
        float width = 0.0f;
        float height = 0.0f;

        if(_size.width > _size.height) {
            // Horizontal
            width = _size.height;
            height = _size.height;
            
        } else if(_size.height > _size.width) {
            // Vertical
            width = _size.width;
            height = _size.width;
            
        } else {
            // Square
            width = _size.width;
            height = _size.height;
        }

        _guage = (Image*)[[Image alloc] initWithImage:_name width:_size.width height:_size.height];
        _inactive = (Image*)[[Image alloc] initWithImage:@"Slider_Inactive" width:64 height:32];
        _active = (Image*)[[Image alloc] initWithImage:@"Slider_Active" width:64 height:32];
        
        float left = (position.x - (_size.width / 2));
        float top = (position.y - (_size.height / 2));
        
        _bounds = CGRectMake(left, top, _size.width, _size.height);
        
        value = 0.5f;
        
        minimum = 0.0f;
        maximum = _size.height;
        
        [self calculate];
    }
    return self;
}


- (void)calculate {
    _distance = (maximum - minimum);                                   // 265 - 48  (217)
    _lowerY = ((position.y - (_size.height / 2)) + minimum);           // 310 - 150 + 48 (208)
    _upperY = (_lowerY + _distance);                                   // 208 + 217 (425)
    
    _slider.y = (_lowerY + (value * _distance));                       // 208 + (0.5 * 217) 316
}

- (void)update:(float)delta {
    [self calculate];
    /*
    NSLog(@"Distance(%.2f), Min(%.2f), Max(%.2f), LowerY(%.2f), UpperY(%.2f), SliderY(%.2f), Value(%.2f)",
        _distance, minimum, maximum, _lowerY, _upperY, _slider.y, value);
    */
}
    
- (void)render {
    [_guage renderAtPoint:position centerOfImage:YES];
    if(_state == 0) {
        [_inactive renderAtPoint:_slider centerOfImage:YES];
    } else {
        [_active renderAtPoint:_slider centerOfImage:YES];
    }
}

- (void)touchUpdate:(UILocation*)newLocation {
    _state = 0;
    
    CGPoint location = newLocation.location;
    if(CGRectContainsPoint(_bounds, location)) {
        if(location.y < _lowerY) location.y = _lowerY;
        if(location.y > _upperY) location.y = _upperY;
        
        float variance = (location.y - _lowerY);
        value = ((1.0f / _distance) * variance);
        
        _state = 1;
    }
}
    
- (void)touchBegan:(UILocation*)location {
    [self touchUpdate:location];
}
    
- (void)touchMoved:(UILocation*)location {
    [self touchUpdate:location];
}
    
- (void)touchEnded:(UILocation*)location {
    [self touchUpdate:location];
    _state = 0;
}
    
- (void)touchCancel:(UILocation*)location {
    [self touchUpdate:location];
    _state = 0;
}

@end
