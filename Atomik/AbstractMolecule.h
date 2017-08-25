//
//  AbstractMolecule.h
//
//  Created by James Bishop on 4/28/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "AbstractEntity.h"

@interface AbstractMolecule : AbstractEntity {
    int ID;
    int unique;
    float radius;
    float scale;
    Animation *explosion;
}

@property (nonatomic, assign) int ID;
@property (nonatomic, assign) int unique;
@property (nonatomic, assign) float radius;
@property (nonatomic, assign) float scale;
@property (nonatomic, retain) Animation *explosion;

- (void)explode;

@end
