//
//  ReviewSession.h
//  vocab_builder
//
//  Created by Andrew Benson on 7/10/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Word;

@interface ReviewSession : NSManagedObject

@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSNumber * minutes;
@property (nonatomic, retain) NSString * timeName;
@property (nonatomic, retain) NSSet *wordAsPrevious;
@property (nonatomic, retain) NSSet *wordAsNext;
@end

@interface ReviewSession (CoreDataGeneratedAccessors)

- (void)addWordAsPreviousObject:(Word *)value;
- (void)removeWordAsPreviousObject:(Word *)value;
- (void)addWordAsPrevious:(NSSet *)values;
- (void)removeWordAsPrevious:(NSSet *)values;

- (void)addWordAsNextObject:(Word *)value;
- (void)removeWordAsNextObject:(Word *)value;
- (void)addWordAsNext:(NSSet *)values;
- (void)removeWordAsNext:(NSSet *)values;

- (BOOL)isGreaterThan:(ReviewSession *)session;
- (ReviewSession *)getNextReviewSession;
- (ReviewSession *)getNextEnabledReviewSession;
+ (ReviewSession *)getFirstReviewSession;
+ (ReviewSession *)getFirstEnabledReviewSession;
+ (ReviewSession *)getStartReviewSession;
+ (NSInteger)numberOfEnabledSessions;

@end
