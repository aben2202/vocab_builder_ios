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
#import "Pronunciation.h"

@implementation DictionaryObjectManager

-(void)getWord:(NSString *)wordString withSuccess:(void (^)(Word *))success failure:(void (^)(NSError *))failure{
//    NSDictionary *params = @{@"limit": @"10",
//                             @"includeRelated": @"false",
//                             @"sourceDictionaries": @"ahd",
//                             @"useCanonical": @"true",
//                             @"includeTags": @"false"};
    
    //since making the api call creates a new thread, we need to set up an operation with its own managed object context (persistentStoreManagedObjectContext).  That is why we do not just use the normal context from 'VocabBuilderDataModel'
    
    NSString *sourceDictionary = @"all";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wordnik.com/v4/word.json/%@/definitions?limit=100&includeRelated=false&sourceDictionaries=%@&useCanonical=true&includeTags=false", wordString, sourceDictionary]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"e26ee69293d80e03b50040ada590aa0cc5a53f23105b45377" forHTTPHeaderField:@"api_key"];
    
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider entryMapping] pathPattern:nil keyPath:nil statusCodes:statusCodeSet];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    __block RKManagedObjectStore *store = [[VocabBuilderDataModel sharedDataModel] objectStore];
    operation.managedObjectCache = store.managedObjectCache;
    operation.managedObjectContext = store.persistentStoreManagedObjectContext;
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        // if there was at least 1 result sent back, save the word.  else, ask for another word
        if (mappingResult.count > 0) {
            Word *theWord = [NSEntityDescription insertNewObjectForEntityForName:@"Word" inManagedObjectContext:store.persistentStoreManagedObjectContext];
        
            theWord.reviewCycleStart = [NSDate date];            
            theWord.entries = mappingResult.set;
            theWord.theWord = wordString;
        
            //save the context
            NSError *error;
            [store.persistentStoreManagedObjectContext save:&error];
            
            //[self addSynonymsToWord:theWord withSuccess:success failure:failure];
            //[self addAntonymsToWord:theWord withSuccess:success failure:failure];
            [self getPronunciationsForWord:theWord withSuccess:success failure:failure];
        }
        
        // word was not found.  ask to try another word
        else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Word Not Found" message:@"The searched word could not be found.  Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
            [alert show];
        }

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

-(void)getPronunciationsForWord:(Word *)word withSuccess:(void (^)(Word *))success failure:(void (^)(NSError *))failure{
    NSString *typeFormat = @"ahd";
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://api.wordnik.com/v4/word.json/%@/pronunciations?limit=1&typeFormat=%@&useCanonical=true", word.theWord, typeFormat]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"e26ee69293d80e03b50040ada590aa0cc5a53f23105b45377" forHTTPHeaderField:@"api_key"];
    
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKResponseDescriptor *responseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:[MappingProvider pronunciationMapping] pathPattern:nil keyPath:nil statusCodes:statusCodeSet];
    RKManagedObjectRequestOperation *operation = [[RKManagedObjectRequestOperation alloc] initWithRequest:request responseDescriptors:@[responseDescriptor]];
    
    __block RKManagedObjectStore *store = [[VocabBuilderDataModel sharedDataModel] objectStore];
    operation.managedObjectCache = store.managedObjectCache;
    operation.managedObjectContext = store.persistentStoreManagedObjectContext;
    
    [operation setCompletionBlockWithSuccess:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        // if there was at least 1 result we add it to the word's pronunciations
        if (mappingResult.count > 0) {
            word.pronunciations = mappingResult.set;
            NSError *error;
            [store.persistentStoreManagedObjectContext save:&error];
        }
        if (success) success(word);
        
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"%@", error.localizedDescription);
        if (failure) failure(error);
    }];
    
    [operation start];
}


@end
