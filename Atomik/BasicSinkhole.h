//
//  BasicSinkhole.h
//
//  Created by James Bishop on 6/24/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "AbstractSinkhole.h"

@interface BasicSinkhole : AbstractSinkhole {
    float angle;
    
    Color4f startColour;
    Color4f startVariance;
    Color4f finishColour;
    Color4f finishVariance;
}

@end
