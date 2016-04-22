//
//  MangoNaturalUser.m
//  iaDriver
//
//  Created by Ievgen Sagidulin on 9/8/15.
//  Copyright (c) 2015 Sagidulin. All rights reserved.
//

#import "MangoNaturalUser.h"
#import "MangoAPI.h"
#import "MangoUser.h"

@implementation MangoNaturalUser


+ (instancetype) manager {
    static MangoNaturalUser *_manager = nil;
    static dispatch_once_t onceTokenBreed;
    dispatch_once(&onceTokenBreed, ^{
        _manager = [[MangoNaturalUser alloc] init];
    });
    return _manager;
}


- (void) getMangoPayUserData:(NSString *)userId withComplitionBlock:(RequestCompletionBlock)block {
    [[MangoAPI instance] getDataFromPath:[NSString stringWithFormat:@"%@/%@", API_METHOD_FETCH_NATURAL_USER,userId] withParamData:nil withBlock:^(id response, NSError *error) {
        if (!error) {
            NSLog(@"got the user:  === %@",response);
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

- (void) createMangoPayUserWithParams:(NSDictionary *)paramDict withComplitionBlock:(RequestCompletionBlock)block {
        
    [[MangoAPI instance] postDataToPath:API_METHOD_CREATE_NATURAL_USER withParamData:paramDict withBlock:^(id response, NSError *error) {
        if (!error) {
            NSLog(@"user created with response:  === %@",response);
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


- (void) editMangoPayUserWithParams:(NSDictionary *)paramDict withComplitionBlock:(RequestCompletionBlock)block {
    
    
    [[MangoAPI instance] putDataToPath:[NSString stringWithFormat:@"%@/%@", API_METHOD_FETCH_NATURAL_USER,[MangoUser manager].user[MangoKeyUserId]] withParamData:paramDict withBlock:^(id response, NSError *error) {
        if (!error) {
            NSLog(@"user edited with response:  === %@",response);
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


- (void) getBankAccountsForUserId:(NSString *)userId  withComplitionBlock:(RequestCompletionBlock)block  {

    
    NSString *urlString = [NSString stringWithFormat:@"%@/%@/%@",API_METHOD_FETCH_USERS,userId,API_METHOD_USER_BANC_ACCOUNTS];
    //Create a banc account for mango user
    [[MangoAPI instance] getDataFromPath:urlString withParamData:nil withBlock:^(id response, NSError *error) {
        if (!error) {
            NSLog(@"user bank accounts:  === %@",response);
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
