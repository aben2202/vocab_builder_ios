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

@interface Global : NSObject

@property(nonatomic,retain)NSURL *dictionaryBaseURL;

@property (nonatomic, retain) NSDictionary *reviewSessions;
@property (strong, nonatomic) NSMutableArray *wordsThatNeedToBeReviewed;


+(Global*)getInstance;

//generic functions for use in all classes
+(NSString *)getTimeAgoInHumanReadable:(NSDate *)previous_time;
-(void)updateNotifications;
-(BOOL)wordsNeedToBeReviewed;
-(void)setReviewWords;

@end
