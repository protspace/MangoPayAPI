//
//  MangoAPI.m
//  iaDriver
//
//  Created by Ievgen Sagidulin on 8/6/15.
//  Copyright (c) 2015 Sagidulin. All rights reserved.
//

#import "MangoAPI.h"
//#import <AFOAuth2Manager/AFOAuth2Manager.h>
#import "OAuthCore.h"

@interface MangoAPI ()

@property (atomic) NSString *userSessionToken;
@property (atomic) double   sessionExpires;
@property (nonatomic, strong) NSTimer *sessionTimer;
//@property (nonatomic, copy) RequestCompletionBlock block;
@end

@implementation MangoAPI
@synthesize userSessionToken, sessionExpires;


+ (instancetype) instance
{
    static MangoAPI* s_instance;
    static dispatch_once_t dispatch;
    dispatch_once(&dispatch, ^{
        s_instance = [[MangoAPI alloc] init];
        s_instance.responseSerializer = [AFJSONResponseSerializer serializer];
        s_instance.requestSerializer  = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];

    });
    
    return s_instance;
}

#pragma mark - Setters and getters for token and user session

- (NSString*) userSessionToken
{
    return userSessionToken;
}

- (void) setUserSessionToken:(NSString *)_userSessionToken
{
    userSessionToken = _userSessionToken;
    NSLog(@"%@", userSessionToken);
    [self.requestSerializer setValue:userSessionToken forHTTPHeaderField:@"Authorization"];
    
}


- (double) sessionExpires
{
    return sessionExpires;
}

- (void) setSessionExpires:(double)_sessionExpires
{
    
    if (self.sessionTimer) {
        [self.sessionTimer invalidate];
    }
    sessionExpires = _sessionExpires;
    
    NSTimeInterval timeInterval =  sessionExpires-120;
    if (timeInterval > 0) {
        self.sessionTimer = [NSTimer scheduledTimerWithTimeInterval:timeInterval target:self selector:@selector(timerFire:) userInfo:nil repeats:NO];
    } else {
        self.sessionTimer = [NSTimer scheduledTimerWithTimeInterval:1200 target:self selector:@selector(timerFire:) userInfo:nil repeats:NO];
        
    }
    
}

- (void)timerFire:(NSTimer *)timer {

    [self.sessionTimer invalidate];
    self.sessionTimer  = nil;
    [self authorizeWithComplitionBlock:nil];
    
}



- (void)authorizeWithComplitionBlock: (RequestCompletionBlock)block {
    

    
    if ([self.sessionTimer isValid]) {
        [self.requestSerializer setValue:self.userSessionToken forHTTPHeaderField:@"Authorization"];

        if (block != nil) {
            block(nil,nil);
        }
        return;
    }
    
    NSLog(@"authorizeWithComplitionBlock");
    //Adding Authorizationg header
    [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:API_CLIEND_ID_Production password:API_PASSFHRASE_Production];
    self.responseSerializer = [AFJSONResponseSerializer serializer];

    //sending request
    NSLog(@"HEADERS =  %@",self.requestSerializer.HTTPRequestHeaders);
    [self POST:[NSString stringWithFormat:@"%@/%@",API_URL_Production,API_METHOD_OAUTH_TOKEN] parameters:@{@"grand_type":@"client_credentials"} success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseAuth = %@",responseObject);
        NSString *accessToken = responseObject[@"access_token"];
        NSString *tokenType   = responseObject[@"token_type"];
        self.userSessionToken = [NSString stringWithFormat:@"%@ %@",tokenType,accessToken];
        double tokenDate = [[responseObject objectForKey:@"expires_in"] doubleValue];
        self.sessionExpires = tokenDate;
        if (block)
            block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error = %@",error.localizedDescription);
         if (block)
             block(nil,error);
    }];
}


-(void)postDataToPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block {

    self.requestSerializer  = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    [self authorizeWithComplitionBlock:^(id response, NSError *error) {
        if (!error) {
            [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            self.responseSerializer = [AFJSONResponseSerializer serializer];

            NSLog(@"HEADERS =  %@",self.requestSerializer.HTTPRequestHeaders);
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@/",API_URL_Production,API_CLIEND_ID_Production,path];
            NSLog(@"url =  %@",url);
            NSLog(@"dictparam =  %@",dictParam);

            [self POST:url parameters:dictParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
                //NSLog(@"responseObject = %@",responseObject);
                block(responseObject,nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
               // NSLog(@"Failed: Status Code: %ld", (long)operation.response.statusCode);
                
                NSLog(@"error = %@",error);
                NSLog(@"error = %@",error.localizedDescription);
                block(nil,error);
            }];
            
            
        } else if (error) {
            
        }
    }];

    
}


-(void) getDataFromPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block {
    
    self.requestSerializer  = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    [self authorizeWithComplitionBlock:^(id response, NSError *error) {
        if (!error) {
            [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            self.responseSerializer = [AFJSONResponseSerializer serializer];
            
            NSLog(@"HEADERS =  %@",self.requestSerializer.HTTPRequestHeaders);
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@",API_URL_Production,API_CLIEND_ID_Production,path];
            NSLog(@"url =  %@",url);
            NSLog(@"dictparam =  %@",dictParam);
            
            [self GET:url parameters:dictParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"responseObject = %@",responseObject);
                block(responseObject,nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // NSLog(@"Failed: Status Code: %ld", (long)operation.response.statusCode);
                
                NSLog(@"error = %@",error.localizedDescription);
                block(nil,error);
            }];
            
            
        } else if (error) {
            
        }
    }];
    
    
}


-(void)putDataToPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block {
    
    self.requestSerializer  = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];
    [self authorizeWithComplitionBlock:^(id response, NSError *error) {
        if (!error) {
            [self.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            self.responseSerializer = [AFJSONResponseSerializer serializer];
            
            NSLog(@"HEADERS =  %@",self.requestSerializer.HTTPRequestHeaders);
            NSString *url = [NSString stringWithFormat:@"%@/%@/%@/",API_URL_Production,API_CLIEND_ID_Production,path];
            NSLog(@"url =  %@",url);
            NSLog(@"dictparam =  %@",dictParam);
            
            [self PUT:url parameters:dictParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"responseObject = %@",responseObject);
                block(responseObject,nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // NSLog(@"Failed: Status Code: %ld", (long)operation.response.statusCode);
                
                NSLog(@"error = %@",error.localizedDescription);
                block(nil,error);
            }];
            
            
        } else if (error) {
            
        }
    }];
    
    
}




-(void)sendCardDetailsToPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block {
    
    [self authorizeWithComplitionBlock:^(id response, NSError *error) {
        if (!error) {
            self.requestSerializer  = [AFHTTPRequestSerializer serializer];
            [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            self.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSLog(@"HEADERS 2=  %@",self.requestSerializer.HTTPRequestHeaders);
            NSLog(@"url2 =  %@",path);
            NSLog(@"dictparam 2=  %@",dictParam);
            
            [self POST:path parameters:dictParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"responseObject2 = %@",responseObject);
                block(responseObject,nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // NSLog(@"Failed: Status Code: %ld", (long)operation.response.statusCode);
                
                NSLog(@"error = %@",error.localizedDescription);
                block(nil,error);
            }];
            
            
        } else if (error) {
            
        }
    }];
}


-(void)editCardRegistrationObjectWithPath:(NSString *)path withParamData:(NSDictionary *)dictParam withBlock:(RequestCompletionBlock)block {
    self.requestSerializer  = [AFJSONRequestSerializer serializerWithWritingOptions:NSJSONWritingPrettyPrinted];

    [self authorizeWithComplitionBlock:^(id response, NSError *error) {
        if (!error) {
            self.requestSerializer  = [AFHTTPRequestSerializer serializer];
            [self.requestSerializer setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
            self.responseSerializer = [AFHTTPResponseSerializer serializer];
            NSLog(@"HEADERS 3=  %@",self.requestSerializer.HTTPRequestHeaders);
            NSLog(@"url 3=  %@",path);
            NSLog(@"dictparam 3=  %@",dictParam);
            
            [self PUT:path parameters:dictParam success:^(AFHTTPRequestOperation *operation, id responseObject) {
                NSLog(@"responseObject 3 = %@",responseObject);
                block(responseObject,nil);
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                // NSLog(@"Failed: Status Code: %ld", (long)operation.response.statusCode);
                
                NSLog(@"error3= %@",error.localizedDescription);
                block(nil,error);
            }];
            
            
        } else if (error) {
            
        }
    }];
    
    
    
}







- (int) getFeeAmountFromDebitedAmount: (int) debitedAmount {
    
    return 1.8*debitedAmount/100 + 18;
}

@end
