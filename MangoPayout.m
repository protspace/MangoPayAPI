//
//  MangoPayout.m
//  iaDriver
//
//  Created by Ievgen Sagidulin on 10/20/15.
//  Copyright © 2015 Sagidulin. All rights reserved.
//

#import "MangoPayout.h"
#import "MangoAPI.h"

@implementation MangoPayout

+ (instancetype) manager {
    static MangoPayout *_manager = nil;
    static dispatch_once_t onceTokenBreed;
    dispatch_once(&onceTokenBreed, ^{
        _manager = [[MangoPayout alloc] init];
    });
    return _manager;
}



- (void) createPayoutFromUserId:(NSString *)userId bankAccountId:(NSString *)bankAccountId debitedWalletId:(NSString *)debitedWalletId debitedFunds:(NSNumber *)debitedFunds fees:(NSNumber *)fees  withComplitionBlock:(RequestCompletionBlock)block {
    
    NSDictionary *dictParam = @{
                                @"AuthorId": userId,
                                @"DebitedWalletId":debitedWalletId,
                                @"DebitedFunds": @{@"Currency": @"EUR",
                                                   @"Amount": debitedFunds},
                                @"Fees": @{@"Currency": @"EUR",
                                           @"Amount": fees},
                                @"BankAccountId":bankAccountId
                                };
    
    
    
    //Create a payout  for mango user
    [[MangoAPI instance] postDataToPath:API_METHOD_CREATE_PAYOUT_BANKWIRE withParamData:dictParam withBlock:^(id response, NSError *error) {
        if (!error) {
            NSLog(@"payout response:  === %@",response);
            if (response) {
                block(response,nil);
                
            } else {
                block(nil,nil);
                
            }
        } else {
            block(nil,error);
        }
    }];
}

@end
