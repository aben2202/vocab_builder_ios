//
//  VocabBuilderObjectManager.m
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "VocabBuilderObjectManager.h"

@implementation VocabBuilderObjectManager

-(void)signInWithEmail:(NSString *)email andPassword:(NSString *)password withSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure{
    [self ]
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
