//
//  Global.h
//  vocab_builder
//
//  Created by Andrew Benson on 6/24/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"
#import <RestKit/RestKit.h>
#import "Word.h"

@interface Global : NSObject

@property(nonatomic,retain)NSURL *dictionaryBaseURL;

@property (nonatomic, retain) NSDictionary *reviewSessions;
@property (strong, nonatomic) NSMutableArray *wordsThatNeedToBeReviewed;
@property BOOL *wordOfTheDayEnabled;
@property (strong, nonatomic) Word *wordOfTheDay;
@property (strong, nonatomic) NSDate *timeForLastWODFetch;


+(Global*)getInstance;

//generic functions for use in all classes
+(NSString *)getTimeAgoInHumanReadable:(NSDate *)previous_time;
-(void)addNotificationsWithWord:(Word *)word;
-(void)removeNotificationsWithWord:(Word *)word;
-(void)updateNotifications;
-(void)updateNotificationsForWord:(Word *)word;
-(BOOL)wordsNeedToBeReviewed;
-(void)setReviewWords;

@end
