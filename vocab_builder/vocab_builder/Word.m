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
#import "Global.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "Dictionary.h"
#import "ExampleUse.h"
#import "Pronunciation.h"


@implementation Word

@dynamic finished;
@dynamic reviewCycleStart;
@dynamic theWord;
@dynamic previousReviewDate;
@dynamic nextReviewDate;
@dynamic antonyms;
@dynamic entries;
@dynamic synonyms;
@dynamic pronunciations;
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
    if (self.nextReviewSession != nil) {
        self.finished = [NSNumber numberWithBool:false];
    }
    else{
        self.finished = [NSNumber numberWithBool:true];
    }
    
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
            if (reviewSession.enabled && ([self.previousReviewSession isGreaterThan:reviewSession] || [self.previousReviewSession.timeName isEqualToString:reviewSession.timeName]) && ![reviewSession.timeName isEqualToString:@"start"]) {
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
//       nextReviewSession to the more recent one.  it returns the number of
//       reviews the current review should count as (if it moved forward one
//       session, it will count as 2).
////////////////////////////////////////////////////////////////////////////////

-(NSInteger)setNextReviewForMostRecentEnabledReview{
    NSInteger numberToReturn = 1;
    while (true) {
        NSDate *now = [NSDate date];
        ReviewSession *theFollowingNextReview = [self.nextReviewSession getNextEnabledReviewSession];
        if (theFollowingNextReview != nil) {
            NSTimeInterval interval = 60 * [theFollowingNextReview.minutes doubleValue];
            NSDate *theFollowingNextReviewDate = [self.reviewCycleStart dateByAddingTimeInterval:interval];
            
            if ([theFollowingNextReviewDate compare:now] == NSOrderedAscending) {
                self.nextReviewSession = theFollowingNextReview;
                numberToReturn += 1;
            }
            else{
                break;
            }

        }
        else{
            break;
        }
    }
    return numberToReturn;
}


////////////////////////////////////////////////////////////////////////////////
// - htmlDefinitionString
//
//   returns an html string to display the definition of this word in a webview
////////////////////////////////////////////////////////////////////////////////

-(NSString *)htmlDefinitionString{
    NSString *htmlString = @"<html><head><style>p.serif{font-family:'Times New Roman',Times,serif;} p.sansserif{font-family:Arial,Helvetica,sans-serif;}</style></head><body>";
    BOOL listedAttributionText = FALSE;
    
    //first add in the pronunciations if any
    for (Pronunciation *pron in self.pronunciations) {
        htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<div style='font-size:20px'><i>%@</i></div>", pron.raw]];
    }
    
    for (Dictionary *dict in [[VocabBuilderDataModel sharedDataModel] dictionaries]) {
        listedAttributionText = FALSE;
        if ([dict.enabled boolValue]) {
            NSMutableArray *entriesArray = [NSMutableArray arrayWithArray:[self.entries allObjects]];
            NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
            NSMutableArray *sortedEntries = [NSMutableArray arrayWithArray:[entriesArray sortedArrayUsingDescriptors:@[sortDesc]]];
            NSMutableArray *exampleUses = [NSMutableArray array];
            NSInteger entriesForThisDictionary = 0;
            
            for (Entry *entry in sortedEntries) {
                if (entry.text != NULL && [dict.wordnikString isEqualToString:entry.sourceDictionary]) {
                    entriesForThisDictionary += 1;
                    
                    //add the dictionary attribution text if we have not already
                    if (listedAttributionText == FALSE) {
                        NSString *attrText = [NSString stringWithFormat:@"<h3><p class='serif'><b>%@</b></p></h3>", entry.attributionText];
                        htmlString = [htmlString stringByAppendingString:attrText];
                        listedAttributionText = TRUE;
                    }
                    //add the dash mark at the beginning of each entry
                    htmlString = [htmlString stringByAppendingString:@"- "];
                    //add the part of speech first in italics
                    if (![entry.partOfSpeech isEqualToString:@""] && entry.partOfSpeech != NULL) {
                        htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"<i>%@</i>. ", entry.partOfSpeech]];
                    }
                    //add the entry text itself (the definition)
                    htmlString = [htmlString stringByAppendingString:[NSString stringWithFormat:@"%@<br><br>", entry.text]];
                    
                    //add any example uses for this entry to the array
                    for (ExampleUse *eu in entry.exampleUses) {
                        [exampleUses addObject:eu];
                    }
                }
            }
            
            //print out the example uses from this dictionary
            if (exampleUses.count != 0) {
                NSString *exUseString = @"<b>Example Uses</b><br>";
                for (ExampleUse *eu in exampleUses) {
                    exUseString = [exUseString stringByAppendingString:[NSString stringWithFormat:@"- %@<br>", eu.text]];
                }
                htmlString = [htmlString stringByAppendingString:exUseString];
            }
            
            //add a horizontal line between each dictionary
            if (entriesForThisDictionary != 0) {
                htmlString = [htmlString stringByAppendingString:@"<hr>"];
            }
        }
    }
    
    
    htmlString = [htmlString stringByAppendingString:@"</p></body>"];
    
    return htmlString;
}


@end
