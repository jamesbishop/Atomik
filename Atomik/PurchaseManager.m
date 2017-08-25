//
//  PurchaseManager.m
//  Atomik
//
//  Created by James on 2/9/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import "PurchaseManager.h"

@implementation PurchaseManager

+ (PurchaseManager*)sharedPurchaseManager {
    static dispatch_once_t once;
    static PurchaseManager *sharedInstance;
    dispatch_once(&once, ^{
        NSSet *productIdentifiers = [NSSet setWithObjects:
                    @"ATOMIK01_NOADVERTS",
                    @"ATOMIK01_STAGE002",
                    @"ATOMIK01_STAGE003",
                    nil];
        sharedInstance = [[self alloc] initWithProductIdentifiers:productIdentifiers];
    });
    return sharedInstance;
}

@end
