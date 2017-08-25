//
//  AbstractSinkhole.h
//
//  Created by James Bishop on 4/28/12.
//  Copyright (c) 2012 Black Cell. All rights reserved.
//

#import "AbstractEntity.h"

@interface AbstractSinkhole : AbstractEntity {
    int ID;
    Emitter *emitter;
}

@property (nonatomic, assign) int ID;
@property (nonatomic, retain) Emitter *emitter;

- (void)boom;

@end
