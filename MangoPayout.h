//
//  MangoPayout.h
//  iaDriver
//
//  Created by Ievgen Sagidulin on 10/20/15.
//  Copyright © 2015 Sagidulin. All rights reserved.
//
typedef void (^RequestCompletionBlock)(id response, NSError *error);

#import <Foundation/Foundation.h>

@interface MangoPayout : NSObject

+ (instancetype)manager;


- (void) createPayoutFromUserId:(NSString *)userId bankAccountId:(NSString *)bankAccountId debitedWalletId:(NSString *)debitedWalletId debitedFunds:(NSNumber *)debitedFunds fees:(NSNumber *)fees  withComplitionBlock:(RequestCompletionBlock)block;


@end
