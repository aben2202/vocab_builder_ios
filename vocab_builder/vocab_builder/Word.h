//
//  Word.h
//  vocab_builder
//
//  Created by andebenson on 7/8/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry, Word;

@interface Word : NSManagedObject

@property (nonatomic, retain) NSNumber * finished;
@property (nonatomic, retain) NSDate * nextReview;
@property (nonatomic, retain) NSString * previousReview;
@property (nonatomic, retain) NSDate * reviewCycleStart;
@property (nonatomic, retain) NSString * theWord;
@property (nonatomic, retain) NSSet *antonyms;
@property (nonatomic, retain) NSSet *entries;
@property (nonatomic, retain) NSSet *synonyms;
@end

@interface Word (CoreDataGeneratedAccessors)

- (void)addAntonymsObject:(Word *)value;
- (void)removeAntonymsObject:(Word *)value;
- (void)addAntonyms:(NSSet *)values;
- (void)removeAntonyms:(NSSet *)values;

- (void)insertObject:(Entry *)value inEntriesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromEntriesAtIndex:(NSUInteger)idx;
- (void)insertEntries:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeEntriesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInEntriesAtIndex:(NSUInteger)idx withObject:(Entry *)value;
- (void)replaceEntriesAtIndexes:(NSIndexSet *)indexes withEntries:(NSArray *)values;
- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSOrderedSet *)values;
- (void)removeEntries:(NSOrderedSet *)values;
- (void)addSynonymsObject:(Word *)value;
- (void)removeSynonymsObject:(Word *)value;
- (void)addSynonyms:(NSSet *)values;
- (void)removeSynonyms:(NSSet *)values;

@end
