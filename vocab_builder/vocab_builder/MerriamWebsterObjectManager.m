//
//  MerriamWebsterObjectManager.m
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "MerriamWebsterObjectManager.h"

@implementation MerriamWebsterObjectManager

-(void)getWord:(void (^)(Word *))success failure:(void (^)(NSError *))failure{
    [self getObjectsAtPath:@"/words" parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Word *theWord = [mappingResult firstObject];
        if (success) success(theWord);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}

//the apps unique Merriam Webster API key
-(NSString*)key{
    return @"124fcfc2-7100-4869-96d6-66f814213009";
}

@end
