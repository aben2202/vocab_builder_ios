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

-(void)signInWithCredentials:(LoginCredentials *)credentials withSuccess:(void (^)(User *))success failure:(void (^)(NSError *))failure{
    NSString *path = @"/login";
    
    [self postObject:credentials path:path parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        User *user = [mappingResult firstObject];
        if (success) success(user);
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
