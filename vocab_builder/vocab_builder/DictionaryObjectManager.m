//
//  DictionaryObjectManager.m
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "DictionaryObjectManager.h"
#import "Entry.h"
#import "MappingProvider.h"
#import "AppDelegate.h"
#import "VocabBuilderDataModel.h"

@implementation DictionaryObjectManager

-(void)getWord:(NSString *)wordString withSuccess:(void (^)(Word *))success failure:(void (^)(NSError *))failure{
//    NSDictionary *params = @{@"limit": @"10",
//                             @"includeRelated": @"false",
//                             @"sourceDictionaries": @"ahd",
//                             @"useCanonical": @"true",
//                             @"includeTags": @"false"};
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wordnik.com/v4/word.json/%@/definitions?limit=10&includeRelated=false&sourceDictionaries=ahd&useCanonical=true&includeTags=false", wordString]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"e26ee69293d80e03b50040ada590aa0cc5a53f23105b45377" forHTTPHeaderField:@"api_key"];
    
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider entryMapping] pathPattern:nil keyPath:nil statusCodes:statusCodeSet];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    __block RKManagedObjectStore *store = [[VocabBuilderDataModel sharedDataModel] objectStore];
    operation.managedObjectCache = store.managedObjectCache;
    operation.managedObjectContext = store.persistentStoreManagedObjectContext;
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        Word *theWord = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:store.persistentStoreManagedObjectContext];
        theWord.reviewCycleStart = [NSDate date];
        theWord.previousReview = @"start";
        theWord.entries = mappingResult.set;
        theWord.theWord = wordString;
    
        //save the context
        NSError *error;
        [store.persistentStoreManagedObjectContext save:&error];
        
        //[self addSynonymsToWord:theWord withSuccess:success failure:failure];
        //[self addAntonymsToWord:theWord withSuccess:success failure:failure];
        
        if (success) success(theWord);

    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];

    [operation start];
}

-(void)addSynonymsToWord:(Word *)word withSuccess:(void (^)(Word *))success failure:(void (^)(NSError *))failure{
    NSString *path = [NSString stringWithFormat:@"%@/relatedWords", word.theWord];
    NSDictionary *params = @{@"limitPerRelationshipType": @"10",
                             @"relationshipTypes": @"synonym",
                             @"useCanonical": @"false"};
    
    [self getObjectsAtPath:path parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        // retrieve synonyms (need to make synonym response mapping)
        
        if (success) success(word);
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) failure(error);
    }];
}

-(void)addAntonymsToWord:(Word *)word withSuccess:(void (^)(Word *))success failure:(void (^)(NSError *))failure{
    
}


@end
