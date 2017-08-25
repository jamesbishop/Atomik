//
//  TappableMolecule.h
//
//  Created by James Bishop on 4/20/13.
//  Copyright (c) 2013 Black Cell. All rights reserved.
//

#import "AbstractMolecule.h"

#define VIBRATE_FREQUENCY   0.02f
#define VIBRATE_VARIANCE    5

@interface TappableMolecule : AbstractMolecule {
    int tapCount;
    float vibrateDelta;
    float vibrateVarianceX;
    float vibrateVarianceY;
    CGPoint marker;
}

- (BOOL)isDoubleTapped;

@end
