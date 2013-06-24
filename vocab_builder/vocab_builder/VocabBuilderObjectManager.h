//
//  VocabBuilderObjectManager.h
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface VocabBuilderObjectManager : RKObjectManager

-(void)loadCurrentWordsWithSuccess:(void (^)(NSArray *words))success
                        failure:(void (^)(NSError *error))failure;

-(void)loadFinishedWordsWithSuccess:(void (^)(NSArray *words))success
                           failure:(void (^)(NSError *error))failure;

@end
