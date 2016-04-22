//
//  MangoCreditCard.h
//  iaDriver
//
//  Created by Ievgen Sagidulin on 9/8/15.
//  Copyright (c) 2015 Sagidulin. All rights reserved.
//
typedef void (^RequestCompletionBlock)(id response, NSError *error);

#import <Foundation/Foundation.h>

@interface MangoCreditCard : NSObject

+ (instancetype)manager;

- (void) createMangoPayCardWithNumber:(NSString *)cardNumber andExpireDate:(NSString *)expDate andCVVCode:(NSString *)cvvCode withComplitionBlock:(RequestCompletionBlock)block;

- (void) getMangoPayUserCardWithBlock:(RequestCompletionBlock)block;

@end
