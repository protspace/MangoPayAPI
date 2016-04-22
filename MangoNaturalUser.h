//
//  MangoNaturalUser.h
//  iaDriver
//
//  Created by Ievgen Sagidulin on 9/8/15.
//  Copyright (c) 2015 Sagidulin. All rights reserved.
//
typedef void (^RequestCompletionBlock)(id response, NSError *error);

#import <Foundation/Foundation.h>

@interface MangoNaturalUser : NSObject

+ (instancetype)manager;

- (void) getMangoPayUserData:(NSString *)userId withComplitionBlock:(RequestCompletionBlock)block;
- (void) createMangoPayUserWithParams:(NSDictionary *)paramDict withComplitionBlock:(RequestCompletionBlock)block;
- (void) editMangoPayUserWithParams:(NSDictionary *)paramDict withComplitionBlock:(RequestCompletionBlock)block;
- (void) getBankAccountsForUserId:(NSString *)userId  withComplitionBlock:(RequestCompletionBlock)block;


    
    
@end
