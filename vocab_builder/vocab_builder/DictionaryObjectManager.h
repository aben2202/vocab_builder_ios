//
//  DictionaryObjectManager.h
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "RKObjectManager.h"
#import "Word.h"

@interface DictionaryObjectManager : RKObjectManager

-(void)getWord:(NSString *)wordString withSuccess:(void (^)(Word *word))success failure:(void (^)(NSError *error))failure;

@end
