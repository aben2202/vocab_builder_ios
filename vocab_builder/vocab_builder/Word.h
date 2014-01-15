//
//  Word.h
//  vocab_builder
//
//  Created by Andrew Benson on 7/10/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry, ReviewSession, Word;

@interface Word : NSManagedObject

@property (nonatomic, retain) NSNumber * finished;
@property (nonatomic, retain) NSDate * reviewCycleStart;
@property (nonatomic, retain) NSString * theWord;
@property (nonatomic, retain) NSDate * previousReviewDate;
@property (nonatomic, retain) NSDate * nextReviewDate;
@property (nonatomic, retain) NSSet *antonyms;
@property (nonatomic, retain) NSSet *entries;
@property (nonatomic, retain) NSSet *synonyms;
@property (nonatomic, retain) NSSet *pronunciations;
@property (nonatomic, retain) ReviewSession *previousReviewSession;
@property (nonatomic, retain) ReviewSession *nextReviewSession;
@property (nonatomic, retain) NSNumber * progress;
@end

@interface Word (CoreDataGeneratedAccessors)

- (void)addAntonymsObject:(Word *)value;
- (void)removeAntonymsObject:(Word *)value;
- (void)addAntonyms:(NSSet *)values;
- (void)removeAntonyms:(NSSet *)values;

- (void)addEntriesObject:(Entry *)value;
- (void)removeEntriesObject:(Entry *)value;
- (void)addEntries:(NSSet *)values;
- (void)removeEntries:(NSSet *)values;

- (void)addSynonymsObject:(Word *)value;
- (void)removeSynonymsObject:(Word *)value;
- (void)addSynonyms:(NSSet *)values;
- (void)removeSynonyms:(NSSet *)values;

- (void)addPronunciationsObject:(Word *)value;
- (void)removePronunciationsObject:(Word *)value;
- (void)addPronunciations:(NSSet *)values;
- (void)removePronunciations:(NSSet *)values;

- (void)updateNextReviewSession;
- (void)updateAfterCompletedReviewWithAnswer:(BOOL)answer;
- (void)resetReviewCycle;
//- (NSNumber *)reviewProgress;
- (void) updateProgress;
- (NSInteger)setNextReviewForMostRecentEnabledReview;
- (NSString *)htmlDefinitionString;

@end
