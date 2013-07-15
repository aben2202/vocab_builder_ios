//
//  VocabBuilderDataModel.m
//  vocab_builder
//
//  Created by andebenson on 7/7/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "VocabBuilderDataModel.h"
#import <CoreData/CoreData.h>
#import "ReviewSession.h"
#import "Word.h"
#import "Dictionary.h"

static VocabBuilderDataModel *instance = nil;

@implementation VocabBuilderDataModel

+(id)sharedDataModel{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance= [VocabBuilderDataModel new];
        }
    }
    return instance;
}

- (NSManagedObjectModel *)managedObjectModel {
    return [NSManagedObjectModel mergedModelFromBundles:nil];
}

- (id)optionsForSqliteStore {
    return @{
             NSInferMappingModelAutomaticallyOption: @YES,
             NSMigratePersistentStoresAutomaticallyOption: @YES
             };
}

- (void)setup {
    self.objectStore = [[RKManagedObjectStore alloc] initWithManagedObjectModel:[self managedObjectModel]];
    
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"VocabBuilder.sqlite"];
    NSLog(@"Setting up store at %@", path);
    [self.objectStore addSQLitePersistentStoreAtPath:path
                              fromSeedDatabaseAtPath:nil
                                   withConfiguration:nil
                                             options:[self optionsForSqliteStore]
                                               error:nil];
    [self.objectStore createManagedObjectContexts];
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


-(NSArray *)words{
    //NSManagedObjectContext *context = self.objectStore.persistentStoreManagedObjectContext;
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Word"
                                                  inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"theWord" ascending:YES];
    [request setSortDescriptors:@[sortDesc]];
    
    NSError *error;
    NSArray *words = [context executeFetchRequest:request error:&error];
    
    // go through and make sure all the words have their review sessions set.
    // if they are not set, reset the cycles from their reviewCycleStart date
    for(Word *word in words){
        if (word.previousReviewSession == nil) {
            [word resetReviewCycle];
        }
    }
    
    NSError *errorMSG;
    [[self managedObjectContext] save:&errorMSG];

    return words;
}

-(NSArray *)dictionaries{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Dictionary"
                                                  inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"humanString" ascending:YES];
    [request setSortDescriptors:@[sortDesc]];
    
    
    NSError *error;
    NSArray *dictionaries = [context executeFetchRequest:request error:&error];
    
    //if this is the first time they load the app, the dictionaries will be blank.
    //  in this case we will create all the dictionaries
    if(dictionaries.count == 0){
        dictionaries = [self createInitialDictionaries];
    }
    
    return dictionaries;
}

-(NSArray *)reviewSessions{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ReviewSession"
                                                  inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"minutes" ascending:YES];
    [request setSortDescriptors:@[sortDesc]];

    
    NSError *error;
    NSArray *reviewSessions = [context executeFetchRequest:request error:&error];
    
    //if this is the first time they load the app, the sessions will be blank.
    //  in this case we will create all the sessions
    if(reviewSessions.count == 0){
        reviewSessions = [self createInitialReviewSessions];
    }
    
//    for (ReviewSession *session in reviewSessions) {
//        NSLog(@"session title = %@, minutes = %d", session.timeName, session.minutes.integerValue);
//    }
    
    return reviewSessions;
}

-(NSArray *)createInitialReviewSessions{
    NSMutableArray *sessions = [NSMutableArray array];
    NSArray *sessionStrings = @[@"start",
                                @"15 minutes",
                                @"1 hour",
                                @"6 hours",
                                @"1 day",
                                @"3 days",
                                @"1 week",
                                @"2 weeks",
                                @"1 month",
                                @"2 months"];
    NSInteger day = 60*24;
    NSArray *sessionMinutes = @[@0,
                                @15,
                                @60,
                                @(60*6),
                                @(day),
                                @(day*3),
                                @(day*7),
                                @(day*14),
                                @(day*30),
                                @(day*61)];
    
    for (int i = 0; i < sessionStrings.count; i++){
        ReviewSession *newSession = [NSEntityDescription insertNewObjectForEntityForName:@"ReviewSession" inManagedObjectContext:[self managedObjectContext]];
        newSession.enabled = @true;
        newSession.timeName = [sessionStrings objectAtIndex:i];
        newSession.minutes = [sessionMinutes objectAtIndex:i];
        [sessions addObject:newSession];
    }
    NSError *error;
    [[self managedObjectContext] save:&error];
    //[[self.objectStore mainQueueManagedObjectContext] save:&error];
    return sessions;
}

-(NSArray *)createInitialDictionaries{
    NSMutableArray *dictionaries = [NSMutableArray array];
    NSArray *humanStrings = @[@"American Heritage",
                              @"Century",
                              @"Wiktionary",
                              @"GCIDE",
                              @"Wordnet"];
    NSArray *wordnikStrings = @[@"ahd-legacy",
                                @"century",
                                @"wiktionary",
                                @"gcide",
                                @"wordnet"];
    
    for (int i = 0; i < humanStrings.count; i++) {
        Dictionary *newDict = [NSEntityDescription insertNewObjectForEntityForName:@"Dictionary" inManagedObjectContext:[self managedObjectContext]];
        newDict.enabled = [NSNumber numberWithBool:true];
        newDict.humanString = [humanStrings objectAtIndex:i];
        newDict.wordnikString = [wordnikStrings objectAtIndex:i];
        [dictionaries addObject:newDict];
    }
    
    NSError *error;
    [[self managedObjectContext] save:&error];
    return dictionaries;
}



@end
