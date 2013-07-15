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
    [entryMapping addAttributeMappingsFromArray:@[@"sourceDictionary",
                                                  @"word",
                                                  @"text",
                                                  @"sequence",
                                                  @"score",
                                                  @"partOfSpeech",
                                                  @"attributionText",
                                                  @"attributionUrl",
                                                  @"seqString",
                                                  @"extendedText"]];
    [entryMapping addRelationshipMappingWithSourceKeyPath:@"labels" mapping:[self labelMapping]];
    [entryMapping addRelationshipMappingWithSourceKeyPath:@"citations" mapping:[self citationMapping]];
    [entryMapping addRelationshipMappingWithSourceKeyPath:@"relatedWords" mapping:[self relatedWordMapping]];
    [entryMapping addRelationshipMappingWithSourceKeyPath:@"exampleUses" mapping:[self exampleUseMapping]];
    [entryMapping addRelationshipMappingWithSourceKeyPath:@"notes" mapping:[self noteMapping]];
    [entryMapping addRelationshipMappingWithSourceKeyPath:@"textProns" mapping:[self textPronMapping]];
    return entryMapping;
}

+(RKEntityMapping *)labelMapping{
    RKEntityMapping *labelMapping = [RKEntityMapping mappingForEntityForName:@"Label" inManagedObjectStore:[[VocabBuilderDataModel sharedDataModel] objectStore]];
    [labelMapping addAttributeMappingsFromArray:@[@"type", @"text"]];
    return labelMapping;
}

+(RKEntityMapping *)citationMapping{
    RKEntityMapping *citationMapping = [RKEntityMapping mappingForEntityForName:@"Citation" inManagedObjectStore:[[VocabBuilderDataModel sharedDataModel] objectStore]];
    [citationMapping addAttributeMappingsFromArray:@[@"cite", @"source"]];
    return citationMapping;
}

+(RKEntityMapping *)relatedWordMapping{
    RKEntityMapping *relatedWordMapping = [RKEntityMapping mappingForEntityForName:@"RelatedWord" inManagedObjectStore:[[VocabBuilderDataModel sharedDataModel] objectStore]];
    [relatedWordMapping addAttributeMappingsFromArray:@[@"words", @"relationshipType"]];
    return relatedWordMapping;
}

+(RKEntityMapping *)exampleUseMapping{
    RKEntityMapping *exampleUseMapping = [RKEntityMapping mappingForEntityForName:@"Label" inManagedObjectStore:[[VocabBuilderDataModel sharedDataModel] objectStore]];
    [exampleUseMapping addAttributeMappingsFromArray:@[@"text"]];
    return exampleUseMapping;
}

+(RKEntityMapping *)noteMapping{
    RKEntityMapping *noteMapping = [RKEntityMapping mappingForEntityForName:@"Note" inManagedObjectStore:[[VocabBuilderDataModel sharedDataModel] objectStore]];
    [noteMapping addAttributeMappingsFromArray:@[@"noteType", @"appliesTo", @"value", @"pos"]];
    return noteMapping;
}

+(RKEntityMapping *)textPronMapping{
    RKEntityMapping *textPronMapping = [RKEntityMapping mappingForEntityForName:@"TextPron" inManagedObjectStore:[[VocabBuilderDataModel sharedDataModel] objectStore]];
    [textPronMapping addAttributeMappingsFromArray:@[@"type", @"text"]];
    return textPronMapping;
}

+(RKEntityMapping *)relatedWordsResponse{
    RKEntityMapping *relatedWordsResponseMapping = [RKEntityMapping mappingForEntityForName:@"RelatedWordsResponse" inManagedObjectStore:[[VocabBuilderDataModel sharedDataModel] objectStore]];
    [relatedWordsResponseMapping addAttributeMappingsFromArray:@[@"words", @"relationshipType"]];
    return relatedWordsResponseMapping;
}

+(void)setupResponseAndRequestDescriptors{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    
    RKResponseDescriptor *definitionResponse = [RKResponseDescriptor responseDescriptorWithMapping:[self entryMapping] pathPattern:nil keyPath:nil statusCodes:statusCodeSet];
    [[DictionaryObjectManager sharedManager] addResponseDescriptor:definitionResponse];
    
    RKResponseDescriptor *relatedWordsResponse = [RKResponseDescriptor responseDescriptorWithMapping:[self relatedWordsResponse] pathPattern:nil keyPath:nil statusCodes:statusCodeSet];
    [[DictionaryObjectManager sharedManager] addResponseDescriptor:relatedWordsResponse];
}

@end
