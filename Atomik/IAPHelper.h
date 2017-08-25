//
//  IAPHelper.h
//  Atomik
//
//  Created by James on 2/11/14.
//  Copyright (c) 2014 Black Cell. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

UIKIT_EXTERN NSString *const IAPHelperProductPurchasedNotification;

typedef void (^RequestProductsCompletionHandler)(BOOL success, NSArray * products);

@interface IAPHelper : NSObject {
    
}

- (id)initWithProductIdentifiers:(NSSet*)productIdentifiers;
- (void)requestProductsWithCompletionHandler:(RequestProductsCompletionHandler)completionHandler;

- (void)buyProduct:(SKProduct*)product;
- (BOOL)productPurchased:(NSString*)productIdentifier;

@end
