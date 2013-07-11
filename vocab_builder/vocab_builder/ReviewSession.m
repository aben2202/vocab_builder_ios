//
//  ReviewSession.m
//  vocab_builder
//
//  Created by Andrew Benson on 7/10/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "ReviewSession.h"
#import "Word.h"
#import "VocabBuilderDataModel.h"


@implementation ReviewSession

@dynamic enabled;
@dynamic minutes;
@dynamic timeName;
@dynamic wordAsPrevious;
@dynamic wordAsNext;

-(BOOL)isGreaterThan:(ReviewSession *)session{
    if ([self.minutes integerValue] > [session.minutes integerValue]){
        return true;
    }
    else{
        return false;
    }
}

-(ReviewSession *)getNextReviewSession{
    if (self != nil) {
        NSArray *reviewSessions = (NSArray *)[[VocabBuilderDataModel sharedDataModel] reviewSessions];
        for (int i = 0; i < reviewSessions.count; i++) {
            ReviewSession *currentIterRS = [reviewSessions objectAtIndex:i];
            if ([currentIterRS isGreaterThan:self]) {
                return currentIterRS;
            }
        }
        return nil;
    }
    else{
        return nil;
    }
}

-(ReviewSession *)getNextEnabledReviewSession{
    if (self != nil) {
        NSArray *reviewSessions = (NSArray *)[[VocabBuilderDataModel sharedDataModel] reviewSessions];
        for (int i = 0; i < reviewSessions.count; i++) {
            ReviewSession *currentIterRS = [reviewSessions objectAtIndex:i];
            if ([currentIterRS isGreaterThan:self] && ([currentIterRS.enabled boolValue])) {
                return currentIterRS;
            }
        }
        return nil;
    }
    else{
        return nil;
    }
}

+(ReviewSession *)getFirstReviewSession{
    NSArray *reviewSessions = (NSArray *)[[VocabBuilderDataModel sharedDataModel] reviewSessions];
    
    // index '0' actually marks the start session, so we use '1' instead
    return [reviewSessions objectAtIndex:1];
}

+(ReviewSession *)getFirstEnabledReviewSession{
    NSArray *reviewSessions = (NSArray *)[[VocabBuilderDataModel sharedDataModel] reviewSessions];
    
    for (int i = 1; i < reviewSessions.count; i++) {
        ReviewSession *currentIterRS = [reviewSessions objectAtIndex:i];
        if (currentIterRS.enabled) {
            return currentIterRS;
        }
    }
    
    return nil;
}

+(ReviewSession *)getStartReviewSession{
    NSArray *reviewSessions = (NSArray *)[[VocabBuilderDataModel sharedDataModel] reviewSessions];
    
    return [reviewSessions objectAtIndex:0];

}

+(NSInteger)numberOfEnabledSessions{
    NSInteger numberToReturn = 0;
    NSArray *reviewSessions = (NSArray *)[[VocabBuilderDataModel sharedDataModel] reviewSessions];
    
    // we don't start at 0, because 0 is the 'start' session
    for (int i = 1; i < reviewSessions.count; i++) {
        ReviewSession *currentSession = [reviewSessions objectAtIndex:i];
        if ([currentSession.enabled boolValue]) {
            numberToReturn++;
        }
    }
    return numberToReturn;
}

@end
