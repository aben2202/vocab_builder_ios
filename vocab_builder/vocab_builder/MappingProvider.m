//
//  MappingProvider.m
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "MappingProvider.h"
#import "Word.h"
#import "Entry.h"
#import "User.h"
#import "VocabBuilderObjectManager.h"
#import "DictionaryObjectManager.h"
#import "Session.h"
#import "VocabBuilderDataModel.h"

@implementation MappingProvider

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// Mappings for Vocab Builder api
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

////session mappings (login/logout)
//+ (RKMapping *)sessionMapping{
//    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Session class]];
//    [mapping addAttributeMappingsFromArray:@[@"success", @"auth_token"]];
//    [mapping addRelationshipMappingWithSourceKeyPath:@"current_user" mapping:[MappingProvider userMapping]];
//    
//    return mapping;
//}
//
//+ (RKMapping *)loginRequestMapping{
//    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
//    [mapping addAttributeMappingsFromArray:@[@"email",@"password"]];
//    
//    return mapping;
//}
//
//+(RKObjectMapping *)userMapping{
//    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
//    [userMapping addAttributeMappingsFromDictionary:@{@"id": @"userId",
//                                                      @"email": @"email"}];
//    [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"words" toKeyPath:@"words" withMapping:[self vocabBuilderWordMapping]]];
//    //[userMapping addRelationshipMappingWithSourceKeyPath:@"words" mapping:[self vocabBuilderWordMapping]];
//    return userMapping;
//}
//
//+(RKObjectMapping *)vocabBuilderWordMapping{
//    RKObjectMapping *wordMapping = [RKObjectMapping mappingForClass:[Word class]];
//    [wordMapping addAttributeMappingsFromDictionary:@{@"id": @"wordId",
//                                                      @"the_word": @"theWord",
//                                                      @"review_cycle_start": @"reviewCycleStart",
//                                                      @"previous_review": @"previousReview",
//                                                      @"finished": @"finished"}];
//    
//    return wordMapping;
//}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// Mappings for Merriam Webster api
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+(RKEntityMapping *)entryMapping{
    RKEntityMapping *entryMapping = [RKEntityMapping mappingForEntityForName:@"Entry" inManagedObjectStore:[[VocabBuilderDataModel sharedDataModel] objectStore]];
    [entryMapping addAttributeMappingsFromArray:@[@"textProns",
                                                  @"sourceDictionary",
                                                  @"exampleUses",
                                                  @"relatedWords",
                                                  @"labels",
                                                  @"citations",
                                                  @"word",
                                                  @"text",
                                                  @"sequence",
                                                  @"score",
                                                  @"partOfSpeech",
                                                  @"attributionText"]];
    return entryMapping;
}

+(void)setupResponseAndRequestDescriptors{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *definitionResponse = [RKResponseDescriptor responseDescriptorWithMapping:[self entryMapping] pathPattern:nil keyPath:nil statusCodes:statusCodeSet];
    [[DictionaryObjectManager sharedManager] addResponseDescriptor:definitionResponse];
}

@end
