//
//  MangoWallet.h
//  iaDriver
//
//  Created by Ievgen Sagidulin on 9/8/15.
//  Copyright (c) 2015 Sagidulin. All rights reserved.
//
typedef void (^RequestCompletionBlock)(id response, NSError *error);

#import <Foundation/Foundation.h>

@interface MangoWallet : NSObject
+ (instancetype)manager;


//Credit Card Methods
-(void)createWalletForOwners:(NSArray *)userIdsArray withDescription:(NSString *)description andCurrency:(NSString *)currency withBlock:(RequestCompletionBlock)block;

- (void) getMangoPayUserWalletWithId:(NSString *)walletId withBlock:(RequestCompletionBlock)block;

@end
