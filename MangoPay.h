//
//  MangoPay.h
//  iaDriver
//
//  Created by Ievgen Sagidulin on 9/11/15.
//  Copyright (c) 2015 Sagidulin. All rights reserved.
//
typedef void (^RequestCompletionBlock)(id response, NSError *error);

#import <Foundation/Foundation.h>

@interface MangoPay : NSObject


/**
 *  payment from credit card to wallet
 *
 *  @param authorUser       <#authorUser description#>
 *  @param cardId           <#cardId description#>
 *  @param сreditedUserId   <#сreditedUserId description#>
 *  @param creditedWalletId <#creditedWalletId description#>
 *  @param debitedAmout     <#debitedAmout description#>
 *  @param fee              <#fee description#>
 *  @param block            <#block description#>
 */
- (void) createMangoPaymentFromAuthorId:(NSString *)authorUser fromCardId:(NSString *)cardId toCreditedUserId: (NSString *)сreditedUserId creditedWalletId:(NSString *) creditedWalletId debitedAmout:(NSNumber *)debitedAmout fee:(NSNumber *)fee  withComplitionBlock:(RequestCompletionBlock)block;


/**
 *  payment from wallet to wallet
 *
 *  @param authorId         <#authorId description#>
 *  @param debitedWalletId  <#debitedWalletId description#>
 *  @param creditedUserId   <#creditedUserId description#>
 *  @param creditedWalletId <#creditedWalletId description#>
 *  @param debitedAmout     <#debitedAmout description#>
 *  @param feeAmount        <#feeAmount description#>
 *  @param block            <#block description#>
 */
- (void) createMangoPaymentFromAuthorId:(NSString *)authorId fromDebitedWalletId:(NSString *)debitedWalletId toCreditedUserId:(NSString *)creditedUserId creditedWalletId:(NSString *)creditedWalletId debitedAmout:(NSNumber *)debitedAmout fee:(NSNumber *)feeAmount  withComplitionBlock:(RequestCompletionBlock)block;
@end
