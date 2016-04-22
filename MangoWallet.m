//
//  MangoWallet.m
//  iaDriver
//
//  Created by Ievgen Sagidulin on 9/8/15.
//  Copyright (c) 2015 Sagidulin. All rights reserved.
//

#import "MangoWallet.h"
#import "MangoAPI.h"
@implementation MangoWallet


+ (instancetype) manager {
    static MangoWallet *_manager = nil;
    static dispatch_once_t onceTokenBreed;
    dispatch_once(&onceTokenBreed, ^{
        _manager = [[MangoWallet alloc] init];
    });
    return _manager;
}


-(void)createWalletForOwners:(NSArray *)userIdsArray withDescription:(NSString *)description andCurrency:(NSString *)currency withBlock:(RequestCompletionBlock)block {
    
    NSDictionary *dictParam = @{
                                @"Owners": userIdsArray,
                                @"Description": description,
                                @"Currency": currency,
                                };
    
    
    [[MangoAPI instance] postDataToPath:API_METHOD_REGISTER_WALLET withParamData:dictParam withBlock:^(id response, NSError *error) {
        if (!error) {
            NSLog(@"wallet created with response:  === %@",response);
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



- (void) getMangoPayUserWalletWithId:(NSString *)walletId withBlock:(RequestCompletionBlock)block {
    [[MangoAPI instance] getDataFromPath:[NSString stringWithFormat:@"%@/%@", API_METHOD_GET_WALLET,walletId] withParamData:nil withBlock:^(id response, NSError *error) {
        if (!error) {
            NSLog(@"Mangopay user's WALLET # %@:    === %@",walletId,response);
            if (response) {
                
                block(response, nil);
            }
        }
    }];
}

@end
