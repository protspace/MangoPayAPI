//
//  MangoAPI.h
//  iaDriver
//
//  Created by Ievgen Sagidulin on 8/6/15.
//  Copyright (c) 2015 Sagidulin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AFNetworking.h"

typedef void (^RequestCompletionBlock)(id response, NSError *error);

@interface MangoAPI : AFHTTPRequestOperationManager

+ (instancetype) instance;



//Universal methods
-(void)getDataFromPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block;
-(void)postDataToPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block;
-(void)putDataToPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block;

//Credit Card Methods
-(void)sendCardDetailsToPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block;
-(void)editCardRegistrationObjectWithPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block;




//Utils
- (int) getFeeAmountFromDebitedAmount: (int) debitedAmount; 
@end
