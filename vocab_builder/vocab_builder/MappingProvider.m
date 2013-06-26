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
#import "Definition.h"
#import "User.h"
#import "VocabBuilderObjectManager.h"
#import "MerriamWebsterObjectManager.h"

@implementation MappingProvider

// The first two mappings are used when calling the Vocab Builder api
+(RKObjectMapping *)userMapping{
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping addAttributeMappingsFromDictionary:@{@"email": @"email",
                                                      @"current_words": @"currentWords",
                                                      @"finished_words": @"finishedWords"}];
    [userMapping addRelationshipMappingWithSourceKeyPath:@"current_words" mapping:[self vocabBuilderWordMapping]];
    [userMapping addRelationshipMappingWithSourceKeyPath:@"finished_words" mapping:[self vocabBuilderWordMapping]];
    return userMapping;
}

+(RKObjectMapping *)vocabBuilderWordMapping{
    RKObjectMapping *wordMapping = [RKObjectMapping mappingForClass:[Word class]];
    [wordMapping addAttributeMappingsFromDictionary:@{@"previous_review": @"previousReview",
                                                      @"next_review": @"nextReview"}];
    
    return wordMapping;
}



// The remaining mappings are used when calling the Merriam Webster api

//+(RKObjectMapping *)merriamWebsterWordMapping{
//    RKObjectMapping *wordMapping = [RKObjectMapping mappingForClass:[Word class]];
//    [wordMapping addRelationshipMappingWithSourceKeyPath:@"entry_list" mapping:[self entryMapping]];
//    
//    return wordMapping;
//}

+(RKObjectMapping *)entryMapping{
    RKObjectMapping *entryMapping = [RKObjectMapping mappingForClass:[Entry class]];
    [entryMapping addAttributeMappingsFromDictionary:@{@"entry[id]": @"theWord",
                                                       @"entry[pr]": @"pronunciationKey",
                                                       @"entry[fl]": @"wordTypes"}];
     
    [entryMapping addRelationshipMappingWithSourceKeyPath:@"def" mapping:[self definitionMapping]];
    return entryMapping;
}

+(RKObjectMapping *)definitionMapping{
    RKObjectMapping *definitionMapping = [RKObjectMapping mappingForClass:[Definition class]];
    [definitionMapping addAttributeMappingsFromDictionary:@{@"date": @"firstUse",
                                                  @"sn": @"senseNumbers",
                                                  @"dt": @"definitions"}];
    return definitionMapping;
}

+(void)setupResponseAndRequestDescriptors{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    VocabBuilderObjectManager *vbObjectManager = [VocabBuilderObjectManager sharedManager];
    MerriamWebsterObjectManager *mwObjectManager = [MerriamWebsterObjectManager sharedManager];
    
    RKResponseDescriptor *userResponse = [RKResponseDescriptor responseDescriptorWithMapping:[self userMapping] pathPattern:nil keyPath:@"user" statusCodes:statusCodeSet];
    [vbObjectManager addResponseDescriptor:userResponse];
    
    RKResponseDescriptor *mwWordResponse = [RKResponseDescriptor responseDescriptorWithMapping:[self entryMapping] pathPattern:nil keyPath:@"entry_list" statusCodes:statusCodeSet];
    [mwObjectManager addResponseDescriptor:mwWordResponse];
}

@end
