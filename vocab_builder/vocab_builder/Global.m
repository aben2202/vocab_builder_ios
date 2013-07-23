//
//  Global.m
//  vocab_builder
//
//  Created by Andrew Benson on 6/24/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "Global.h"
#import "Word.h"
#import "ReviewSession.h"
#import "VocabBuilderDataModel.h"

@implementation Global

@synthesize dictionaryBaseURL = _dictionaryBaseURL;

-(id)init{
    self = [super init];
    return self;
}

//-(NSURL *)vbBaseURL{
//    return [NSURL URLWithString:@"http://localhost:3000/api/v1"];
//    //return [NSURL URLWithString:@"http://vocab-builder.herokuapp.com"];
//}

-(NSURL *)dictionaryBaseURL{
    return [NSURL URLWithString:@"http://api.wordnik.com/v4/word.json/"];
}

static Global *instance =nil;
+(Global *)getInstance
{
    @synchronized(self)
    {
        if(instance==nil)
        {
            instance = [Global new];
        }
    }
    return instance;
}

+(NSString *)getTimeAgoInHumanReadable:(NSDate *)previous_time{
    //calculate how recently the route was added
    
    unsigned int unitFlags = NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit;
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *components = [calendar components:unitFlags fromDate:previous_time  toDate:[NSDate date]  options:0];
    
    NSUInteger preservedComponents = (NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit);
    NSDate *thePreviousMidnight = [calendar dateFromComponents:[calendar components:preservedComponents fromDate:[NSDate date]]];
    
    NSDateComponents *componentsFromPreviousMidnight = [calendar components:NSDayCalendarUnit | NSSecondCalendarUnit
                                                                   fromDate:previous_time
                                                                     toDate:thePreviousMidnight
                                                                    options:0];
    
    NSInteger daysAgo = [componentsFromPreviousMidnight day] + 1;
    
    if (daysAgo >= 7){
        //just return the date
        return [NSDateFormatter localizedStringFromDate:previous_time
                                              dateStyle:NSDateFormatterShortStyle
                                              timeStyle:NSDateFormatterNoStyle];
    }
    else if (daysAgo > 1){
        return [NSString stringWithFormat:@"%d days ago", daysAgo];
    }
    else if (daysAgo == 1 && ([previous_time compare:thePreviousMidnight] == NSOrderedAscending)){
        return @"yesterday";
    }
    //it was sometime today
    else if ([components hour] > 1){
        return [NSString stringWithFormat:@"%d hours ago", [components hour]];
    }
    else if ([components hour] == 1){
        return [NSString stringWithFormat:@"%d hour ago", [components hour]];
    }
    else if ([components minute] > 1){
        return [NSString stringWithFormat:@"%d min ago", [components minute]];
    }
    else{
        return @"1 minute ago";
    }
    
}

-(void)addNotificationsWithWord:(Word *)word{
    for(ReviewSession *reviewSession in [[VocabBuilderDataModel sharedDataModel] reviewSessions]){
        if ([reviewSession.enabled boolValue] && [reviewSession isGreaterThan:word.previousReviewSession]) {
            //create the notification
            UILocalNotification *newNotification = [[UILocalNotification alloc] init];
            NSTimeInterval interval = 60 * [reviewSession.minutes doubleValue];
            newNotification.fireDate = [word.reviewCycleStart dateByAddingTimeInterval:interval];
            newNotification.alertAction = @"Review Session";
            newNotification.alertBody = [NSString stringWithFormat:@"It is time to review the word '%@'.", word.theWord];
            newNotification.soundName = UILocalNotificationDefaultSoundName;
            newNotification.applicationIconBadgeNumber = 1;
            [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
        }
    }
}

-(void)removeNotificationsWithWord:(Word *)word{
    for (UILocalNotification *localNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        if ([localNotif.alertBody rangeOfString:[NSString stringWithFormat:@"'%@'", word.theWord]].location == NSNotFound) {
            //not a notification for this word so just skip
        }
        else
        {
            //notification for this word
            [[UIApplication sharedApplication] cancelLocalNotification:localNotif];
            //NSLog(@"Cancelling notification: %@ at %@", localNotif.alertBody, [localNotif.fireDate description]);
        }
    }
}

-(void)updateNotifications{
    //there is no need to sort the notifications since only the soonest-firing 64 are stored
    
    // first erase all current notifications
    NSLog(@"updating local notifications");
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    
    // now iterate through all the words and review sessions to create the notifications
    for (Word *word in [[VocabBuilderDataModel sharedDataModel] words]){
        for(ReviewSession *reviewSession in [[VocabBuilderDataModel sharedDataModel] reviewSessions]){
            // in order to create a notification for this review session, it must be enabled and we must not have already performed the review session
            if ([reviewSession.enabled boolValue] && [reviewSession isGreaterThan:word.previousReviewSession]) {
                //create the notification
                UILocalNotification *newNotification = [[UILocalNotification alloc] init];
                NSTimeInterval interval = 60 * [reviewSession.minutes doubleValue];
                newNotification.fireDate = [word.reviewCycleStart dateByAddingTimeInterval:interval];
                newNotification.alertAction = @"Review Session";
                newNotification.alertBody = [NSString stringWithFormat:@"It is time to review the word '%@'.", word.theWord];
                newNotification.soundName = UILocalNotificationDefaultSoundName;
                newNotification.applicationIconBadgeNumber = 1;
                [[UIApplication sharedApplication] scheduleLocalNotification:newNotification];
            }
        }
    }
    
    // the notifications were not sorted above so we could not apply a badge number to them.  so now, we iterate through all the notifications, creating new ones to replace them that now have badge numbers.
//    NSInteger badgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber];
//    for (UILocalNotification *localNote in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
//        UILocalNotification *noteWithBadge = [[UILocalNotification alloc] init];
//        noteWithBadge.fireDate = localNote.fireDate;
//        noteWithBadge.alertAction = @"Review Session";
//        noteWithBadge.alertBody = localNote.alertBody;
//        noteWithBadge.soundName = localNote.soundName;
//        badgeNumber = badgeNumber + 1;
//        noteWithBadge.applicationIconBadgeNumber = badgeNumber;
//        [[UIApplication sharedApplication] cancelLocalNotification:localNote];
//
//        [[UIApplication sharedApplication] scheduleLocalNotification:noteWithBadge];
////        NSLog(@"Local Notification scheduled for %@ with badge number %d", localNote.fireDate.description, localNote.applicationIconBadgeNumber);
//    }

    NSError *error;
    [[self managedObjectContext] save:&error];
}

-(void)updateNotificationsForWord:(Word *)word{
    //first remove all current notifications for this word
    [self removeNotificationsWithWord:word];
    
    //now add the correct notifications back
    [self addNotificationsWithWord:word];
}

-(BOOL)wordsNeedToBeReviewed{
    [self setReviewWords];
    
    if (self.wordsThatNeedToBeReviewed.count > 0) {
        return YES;
    }
    else{
        return NO;
    }
}

-(void)setReviewWords{
    [self.wordsThatNeedToBeReviewed removeAllObjects];
    NSArray *words = [[VocabBuilderDataModel sharedDataModel] words];
    
    NSDate *now = [NSDate date];
    for (Word *currentWord in words) {
        if ([currentWord.nextReviewDate compare:now] == NSOrderedAscending) {
            //add to list of words that need to be reviewed
            [self.wordsThatNeedToBeReviewed addObject:currentWord];
        }
    }
    if (self.wordsThatNeedToBeReviewed.count == 0) {
        [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    }
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}





@end
