//
//  MangoPay.m
//  iaDriver
//
//  Created by Ievgen Sagidulin on 9/11/15.
//  Copyright (c) 2015 Sagidulin. All rights reserved.
//

#import "MangoPay.h"
#import "MangoAPI.h"

@implementation MangoPay

- (void) createMangoPaymentFromAuthorId:(NSString *)authorId fromCardId:(NSString *)cardId toCreditedUserId:(NSString *)creditedUserId creditedWalletId:(NSString *)creditedWalletId debitedAmout:(NSNumber *)debitedAmout fee:(NSNumber *)feeAmount  withComplitionBlock:(RequestCompletionBlock)block {
    
    NSDictionary *dictParam = @{
                                @"Tag": @"testTag",
                                @"AuthorId": authorId,
                                @"CreditedUserId": creditedUserId,
                                @"CreditedWalletId":creditedWalletId,
                                @"DebitedFunds": @{@"Currency": @"EUR",
                                                   @"Amount": debitedAmout},
                                @"Fees": @{@"Currency": @"EUR",
                                           @"Amount": feeAmount},
                                @"CardId": cardId,
                                @"SecureModeReturnURL": @"https://www.mysite.com",
                                };
    
    [[MangoAPI instance] postDataToPath:API_METHOD_DIRECT_PAY withParamData:dictParam withBlock:^(id response, NSError *error) {
        block (response, error);
    }];

    
    
}


- (void) createMangoPaymentFromAuthorId:(NSString *)authorId fromDebitedWalletId:(NSString *)debitedWalletId toCreditedUserId:(NSString *)creditedUserId creditedWalletId:(NSString *)creditedWalletId debitedAmout:(NSNumber *)debitedAmout fee:(NSNumber *)feeAmount  withComplitionBlock:(RequestCompletionBlock)block {
    
    NSDictionary *dictParam = @{
                                @"AuthorId": authorId,
                                @"DebitedWalletID":debitedWalletId,
                                @"CreditedWalletId":creditedWalletId,
                                @"DebitedFunds": @{@"Currency": @"EUR",
                                                   @"Amount": debitedAmout},
                                @"Fees": @{@"Currency": @"EUR",
                                           @"Amount": feeAmount},
                                @"SecureModeReturnURL": @"https://www.mysite.com",
                                };
    
    [[MangoAPI instance] postDataToPath:API_METHOD_WALLET_TO_WALLET_PAY withParamData:dictParam withBlock:^(id response, NSError *error) {
        block (response, error);
    }];
    
    
    
}



@end
