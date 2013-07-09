//
//  Word.m
//  vocab_builder
//
//  Created by Andrew Benson on 6/26/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "Word.h"

@implementation Word

@dynamic theWord;
@dynamic entries;
@dynamic reviewCycleStart;
@dynamic previousReview;
@dynamic nextReview;
@dynamic finished;
@dynamic antonyms;
@dynamic synonyms;

-(NSDate *)nextReview{
    if (self.finished == false) {
        NSTimeInterval interval;
        if ([self.previousReview isEqualToString:@"start"]) {
            // interval of 15 minutes
            interval = 60*15;
        }
        else if ([self.previousReview isEqualToString:@"15 minutes"]){
            // interval of 1 hour
            interval = 60*60;
        }
        else if ([self.previousReview isEqualToString:@"1 hour"]){
            // interval of 6 hours
            interval = 60*60*6;
        }
        else if ([self.previousReview isEqualToString:@"6 hours"]){
            // interval of 1 day
            interval = 60*60*24;
        }
        else if ([self.previousReview isEqualToString:@"1 day"]){
            // interval of 3 days
            interval = 60*60*24*3;
        }
        else if ([self.previousReview isEqualToString:@"3 days"]){
            // interval of 1 week
            interval = 60*60*24*7;
        }
        else if ([self.previousReview isEqualToString:@"1 week"]){
            // interval of 2 weeks
            interval = 60*60*24*14;
        }
        else if ([self.previousReview isEqualToString:@"2 weeks"]){
            // interval of 1 month
            interval = 60*60*24*30;
        }
        else {
            // interval of 2 months
            interval = 60*60*24*61;
        }
        return [NSDate dateWithTimeInterval:interval sinceDate:self.reviewCycleStart];
    }
    else{
        return nil;
    }
}

@end
