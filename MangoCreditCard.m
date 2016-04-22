//
//  MangoCreditCard.m
//  iaDriver
//
//  Created by Ievgen Sagidulin on 9/8/15.
//  Copyright (c) 2015 Sagidulin. All rights reserved.
//

#import "MangoCreditCard.h"
#import "MangoAPI.h"
#import "MangoCard.h"
#import "MangoUser.h"

@interface MangoCreditCard ()

@property (strong, nonatomic) RequestCompletionBlock cardRegisterComplitionBlock;
@property (strong, nonatomic) NSString *             cardNumber;
@property (strong, nonatomic) NSString *             expDate;
@property (strong, nonatomic) NSString *             cvvCode;

@end


@implementation MangoCreditCard


+ (instancetype) manager {
    static MangoCreditCard *_manager = nil;
    static dispatch_once_t onceTokenBreed;
    dispatch_once(&onceTokenBreed, ^{
        _manager = [[MangoCreditCard alloc] init];
    });
    return _manager;
}


- (void) createMangoPayCardWithNumber:(NSString *)cardNumber andExpireDate:(NSString *)expDate andCVVCode:(NSString *)cvvCode withComplitionBlock:(RequestCompletionBlock)block  {
    NSDictionary *dictParam = @{
                                @"UserId": [MangoUser manager].user[MangoKeyUserId],
                                @"Currency": @"EUR",
                                };

    self.cardRegisterComplitionBlock = [block copy];
    self.cardNumber = cardNumber;
    self.cvvCode = cvvCode;
    self.expDate = expDate;
    
    //Create a « CardRegistration » Object
    [[MangoAPI instance] postDataToPath:API_METHOD_REGISTER_CARD withParamData:dictParam withBlock:^(id response, NSError *error) {
        if (!error) {

            [self sendCardDetails:response];
        }
    }];
    
    
}

-(void) sendCardDetails: (NSDictionary *)cardRegistrationResponseDict {

NSDictionary *dictParam = @{
                            @"accessKeyRef": cardRegistrationResponseDict[MangoKeyCardAccessKey],
                            @"data":cardRegistrationResponseDict[MangoKeyCardPreregistrationData],
                            @"cardExpirationDate":self.expDate,
                            @"cardCvx":self.cvvCode,
                            @"cardNumber":self.cardNumber,
                            };

    [[MangoAPI instance] sendCardDetailsToPath:cardRegistrationResponseDict[MangoKeyCardRegistrationURL] withParamData:dictParam withBlock:^(id response, NSError *error) {
    if (!error) {
        NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
        NSLog(@"response data: %@",str);
        if ([str hasPrefix:@"errorCode"]) {
            NSLog(@"%@",str);
        } else  {
            [self editCardWithId:cardRegistrationResponseDict[MangoKeyCardRegisteredId] withRegistrationData:str];}
        
        
    }
    }];
}


- (void) editCardWithId:regCardId withRegistrationData:(NSString *)registrationData  {
    NSDictionary *dictParam = @{
                                @"RegistrationData":registrationData
                                };
    NSString *url = [NSString stringWithFormat:@"%@/%@/%@/%@",API_URL_Production,API_CLIEND_ID_Production,API_METHOD_REGISTER_CARD_PUT,regCardId];
    
    [[MangoAPI instance] editCardRegistrationObjectWithPath:url  withParamData:dictParam withBlock:^(id response, NSError *error) {
        if (!error) {
            NSString *str = [[NSString alloc] initWithData:response encoding:NSUTF8StringEncoding];
            //NSLog(@"response data: %@",str);
            NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
            id json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            NSLog(@"json = %@",json);
            
            if ([json[@"ResultMessage"] isEqualToString:@"Success"]) {
                NSLog(@"URA");
                
                [self getMangoPayUserCardWithBlock:^(id response, NSError *error) {
                    
                    NSLog(@"new CARD is here: %@",response);
                    self.cardRegisterComplitionBlock (response, nil);
                }];
            }
            
        }
    }];
}


- (void) getMangoPayUserCardWithBlock:(RequestCompletionBlock)block {
    [[MangoAPI instance] getDataFromPath:[NSString stringWithFormat:@"%@/%@/cards", API_METHOD_FETCH_USERS,[MangoUser manager].user[MangoKeyUserId]] withParamData:nil withBlock:^(id response, NSError *error) {
        if (!error) {
            NSLog(@"Mangopay user's CARDS:    === %@",response);
            if (response && [response count]) {
                
                block(response[0], nil);
            }
        }
    }];
}


- (void) deactivateAllCardsForUser:(NSString *)userId withBlock:(RequestCompletionBlock)block {
    
    __weak typeof(self) weakSelf = self;

    [[MangoAPI instance] getDataFromPath:[NSString stringWithFormat:@"%@/%@/cards", API_METHOD_FETCH_USERS,[MangoUser manager].user[MangoKeyUserId]] withParamData:nil withBlock:^(id response, NSError *error) {
        if (!error) {
            NSLog(@"all Mangopay user's CARDS:    === %@",response);
            if (response && [response count]) {
                
                for (NSDictionary *card in response) {
                    if ([card[@"Active"] isEqualToString:@"1"]) {
                        [weakSelf deactivateCardWithId:card[MangoKeyUserId]];
                    }
                }
                block(response[0], nil);
            }
        }
    }];
}


-(void) deactivateCardWithId: (NSString *)cardId {
    

    [[MangoAPI instance] getDataFromPath:[NSString stringWithFormat:@"%@/%@", API_METHOD_EDIT_CARD_PUT,cardId] withParamData:nil withBlock:^(id response, NSError *error) {
        if (!error) {
            NSLog(@"deactivated  CARD:    === %@",response);
            if (response && [response count]) {
                
            }
        }
    }];
}


@end
