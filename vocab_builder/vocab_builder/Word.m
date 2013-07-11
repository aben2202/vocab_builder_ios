//
//  Word.m
//  vocab_builder
//
//  Created by Andrew Benson on 7/10/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "Word.h"
#import "Entry.h"
#import "ReviewSession.h"
#import "Word.h"
#import "VocabBuilderDataModel.h"


@implementation Word

@dynamic finished;
@dynamic reviewCycleStart;
@dynamic theWord;
@dynamic previousReviewDate;
@dynamic nextReviewDate;
@dynamic antonyms;
@dynamic entries;
@dynamic synonyms;
@dynamic previousReviewSession;
@dynamic nextReviewSession;

////////////////////////////////////////////////////////////////////////////////
// - updateNextReviewSession
//
//   this method will take a word's previousReviewSession, find the next enabled
//        reviewSession and set the word's nextReviewSession to it
////////////////////////////////////////////////////////////////////////////////

-(void)updateNextReviewSession{
    self.nextReviewSession = [self.previousReviewSession getNextEnabledReviewSession];    
    if (self.nextReviewSession == nil) {
        // there is no future review session enabled
        self.finished = [NSNumber numberWithBool:true];
    }
    else{
        self.finished = [NSNumber numberWithBool:false];
        NSTimeInterval interval = 60 * [self.nextReviewSession.minutes doubleValue];
        self.nextReviewDate = [self.reviewCycleStart dateByAddingTimeInterval:interval];
    }
    NSError *error;
    [[self managedObjectContext] save:&error];
}


////////////////////////////////////////////////////////////////////////////////
// - updateAfterCompletedReviewWithAnswer
//
//   this method updates a word's properties given the answer the it's past review.
//       if they knew the answer, we update the next review to the next enabled
//       reviewSession (if any).  if they did not know the answer, we reset the
//       review cycle.
////////////////////////////////////////////////////////////////////////////////

-(void)updateAfterCompletedReviewWithAnswer:(BOOL)answer{
    if (answer == YES) {
        //update with 'yes' answer here
        ReviewSession *thisReviewSession = self.nextReviewSession;
        self.previousReviewSession = thisReviewSession;
        self.nextReviewSession = [thisReviewSession getNextEnabledReviewSession];
        if (self.nextReviewSession != nil) {
            NSTimeInterval interval = 60 * [[self.nextReviewSession minutes] integerValue];
            self.nextReviewDate = [self.reviewCycleStart dateByAddingTimeInterval:interval];
        }
    }
    else{ //they did not know the definition so we reset the cycle
        [self resetReviewCycle];
    }
    
    if (self.nextReviewSession == nil) {
        self.finished = [NSNumber numberWithBool:true];
        self.nextReviewDate = nil;
    }
}


////////////////////////////////////////////////////////////////////////////////
// - resetReviewCycle
//
//   this method resets the review cycle for the word with the current time as
//       the starting point
////////////////////////////////////////////////////////////////////////////////

-(void)resetReviewCycle{
    NSDate *now = [NSDate date];
    self.reviewCycleStart = now;
    self.previousReviewSession = [ReviewSession getStartReviewSession];
    self.previousReviewDate = now;
    self.nextReviewSession = [ReviewSession getFirstEnabledReviewSession];
    NSTimeInterval interval = 60 * [[self.nextReviewSession minutes] integerValue];
    self.nextReviewDate = [self.reviewCycleStart dateByAddingTimeInterval:interval];
    self.finished = [NSNumber numberWithBool:false];
}


////////////////////////////////////////////////////////////////////////////////
// - reviewProgress
//
//   this method returns the review progress for the word by checking the enabled
//       reviewSessions.  the return value will be a decimal between 0 and 1.
////////////////////////////////////////////////////////////////////////////////

-(NSNumber *)reviewProgress{
    if ([self.previousReviewSession.timeName isEqualToString:@"start"]) {
        return 0;
    }
    else{
        NSNumber *totalReviews = [NSNumber numberWithInteger:[ReviewSession numberOfEnabledSessions]];
        NSNumber *enabledSessionsCompleted = 0;
        
        for (ReviewSession *reviewSession in [[VocabBuilderDataModel sharedDataModel] reviewSessions]) {
            if (reviewSession.enabled && ([self.previousReviewSession isGreaterThan:reviewSession])) {
                enabledSessionsCompleted = [NSNumber numberWithInt:([enabledSessionsCompleted integerValue] + 1)];
            }
        }
        
        NSNumber *numberToReturn = [NSNumber numberWithDouble:([enabledSessionsCompleted doubleValue]/[totalReviews doubleValue])];
        return numberToReturn;
    }
}


////////////////////////////////////////////////////////////////////////////////
// - setNextReviewForMostRecentEnabledReview
//
//   this method looks at the word's nextReviewSession and makes sure there are
//       no more recent reviewSessions to now.  if there are, it sets its
//       nextReviewSession to the more recent one.
////////////////////////////////////////////////////////////////////////////////

-(void)setNextReviewForMostRecentEnabledReview{
    while (true) {
        NSDate *now = [NSDate date];
        ReviewSession *theFollowingNextReview = [self.nextReviewSession getNextEnabledReviewSession];
        NSTimeInterval interval = 60 * [theFollowingNextReview.minutes doubleValue];
        NSDate *theFollowingNextReviewDate = [self.reviewCycleStart dateByAddingTimeInterval:interval];
        
        if ([theFollowingNextReviewDate compare:now] == NSOrderedAscending) {
            self.nextReviewSession = theFollowingNextReview;
        }
        else{
            break;
        }
    }
}

@end
