//
//  VocabBuilderObjectManager.m
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "VocabBuilderObjectManager.h"
#import "LoginCredentials.h"

@implementation VocabBuilderObjectManager

-(void)signInWithCredentials:(LoginCredentials *)credentials withSuccess:(void (^)(Session *))success failure:(void (^)(NSError *))failure{
    NSString *path = @"login";
    NSDictionary *params = @{@"credentials[email]": credentials.email,
                             @"credentials[password]": credentials.password};
    
    [self postObject:credentials path:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Session *session = [mappingResult firstObject];
        if (success) success(session);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

-(void)loadCurrentWordsWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSDictionary *params = @{@"type" : @"current"};
    [self getObjectsAtPath:@"/words" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) success([mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}

-(void)loadFinishedWordsWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    NSDictionary *params = @{@"type" : @"finished"};
    [self getObjectsAtPath:@"/words" parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) success([mappingResult array]);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}

@end
