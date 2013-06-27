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
#import "Session.h"

@implementation MappingProvider

//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// Mappings for Vocab Builder api
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//session mappings (login/logout)
+ (RKMapping *)sessionMapping{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Session class]];
    [mapping addAttributeMappingsFromArray:@[@"success", @"auth_token"]];
    [mapping addRelationshipMappingWithSourceKeyPath:@"current_user" mapping:[MappingProvider userMapping]];
    
    return mapping;
}

+ (RKMapping *)loginRequestMapping{
    RKObjectMapping *mapping = [RKObjectMapping requestMapping];
    [mapping addAttributeMappingsFromArray:@[@"email",@"password"]];
    
    return mapping;
}

+(RKObjectMapping *)userMapping{
    RKObjectMapping *userMapping = [RKObjectMapping mappingForClass:[User class]];
    [userMapping addAttributeMappingsFromDictionary:@{@"id": @"userId",
                                                      @"email": @"email"}];
    [userMapping addPropertyMapping:[RKRelationshipMapping relationshipMappingFromKeyPath:@"words" toKeyPath:@"words" withMapping:[self vocabBuilderWordMapping]]];
    //[userMapping addRelationshipMappingWithSourceKeyPath:@"words" mapping:[self vocabBuilderWordMapping]];
    return userMapping;
}

+(RKObjectMapping *)vocabBuilderWordMapping{
    RKObjectMapping *wordMapping = [RKObjectMapping mappingForClass:[Word class]];
    [wordMapping addAttributeMappingsFromDictionary:@{@"id": @"wordId",
                                                      @"the_word": @"theWord",
                                                      @"review_cycle_start": @"reviewCycleStart",
                                                      @"previous_review": @"previousReview",
                                                      @"finished": @"finished"}];
    
    return wordMapping;
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////// Mappings for Merriam Webster api
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

+(RKObjectMapping *)merriamWebsterWordMapping{
    RKObjectMapping *wordMapping = [RKObjectMapping mappingForClass:[Word class]];
    [wordMapping addRelationshipMappingWithSourceKeyPath:@"entry_list" mapping:[self entryMapping]];
    
    return wordMapping;
}

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
    
//    RKResponseDescriptor *userResponse = [RKResponseDescriptor responseDescriptorWithMapping:[self userMapping] pathPattern:nil keyPath:@"user" statusCodes:statusCodeSet];
//    [vbObjectManager addResponseDescriptor:userResponse];
//    
    RKResponseDescriptor *mwWordResponse = [RKResponseDescriptor responseDescriptorWithMapping:[self entryMapping] pathPattern:nil keyPath:@"entry_list" statusCodes:statusCodeSet];
    [[MerriamWebsterObjectManager sharedManager] addResponseDescriptor:mwWordResponse];
    
    // sessions /////////////
    // requests
//    RKRequestDescriptor *loginRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:[self loginRequestMapping] objectClass:[LoginCredentials class] rootKeyPath:@"credentials"];
//    [vbObjectManager addRequestDescriptor:loginRequestDescriptor];
//    // responses
//    RKResponseDescriptor *session = [RKResponseDescriptor responseDescriptorWithMapping:[self sessionMapping] pathPattern:@"login" keyPath:nil statusCodes:statusCodeSet];
//    [vbObjectManager addResponseDescriptor:session];
//    
    
//    // error mappings
//    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[RKErrorMessage class]];
//    [errorMapping addPropertyMapping:[RKAttributeMapping attributeMappingFromKeyPath:@"error" toKeyPath:@"errorMessage"]];
//    [vbObjectManager addResponseDescriptor:[RKResponseDescriptor responseDescriptorWithMapping:errorMapping pathPattern:nil keyPath:@"error" statusCodes:RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError)]];

}

@end
