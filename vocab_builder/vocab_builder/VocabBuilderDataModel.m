//
//  VocabBuilderDataModel.m
//  vocab_builder
//
//  Created by andebenson on 7/7/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "VocabBuilderDataModel.h"
#import <CoreData/CoreData.h>

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
    
    NSString *path = [RKApplicationDataDirectory() stringByAppendingPathComponent:@"vocabBuilder.sqlite"];
    NSLog(@"Setting up store at %@", path);
    [self.objectStore addSQLitePersistentStoreAtPath:path
                              fromSeedDatabaseAtPath:nil
                                   withConfiguration:nil
                                             options:[self optionsForSqliteStore]
                                               error:nil];
    [self.objectStore createManagedObjectContexts];
}


@end
