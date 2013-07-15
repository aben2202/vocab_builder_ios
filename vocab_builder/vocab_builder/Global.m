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

-(void)updateNotifications{
    // first erase all current notifications
    NSLog(@"updating local notifications");
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    NSMutableArray *localNotifications = [NSMutableArray array];
    
    // now iterate through all the words and review sessions adding the notifications to an array.
    //    we don't just create the notification on the spot because the operating system will only remember
    //    64 notifications, so we want to sort them to make sure we add the first notifications
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
                //newNotification.applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber + 1;
                newNotification.applicationIconBadgeNumber = 1;
                newNotification.soundName = UILocalNotificationDefaultSoundName;
                [localNotifications addObject:newNotification];
            }
        }
    }
    
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"fireDate" ascending:YES];
    NSArray *sortedNotifications = [localNotifications sortedArrayUsingDescriptors:@[sortDesc]];
    if (sortedNotifications.count < 65) {
        for (UILocalNotification *localNotif in sortedNotifications) {
            [[UIApplication sharedApplication] scheduleLocalNotification:localNotif];
        }
    }
    else{
        for (int i = 0; i < 64; i++) {
            [[UIApplication sharedApplication] scheduleLocalNotification:[sortedNotifications objectAtIndex:i]];
        }
    }
    
    for (UILocalNotification *localNotif in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        NSLog(@"Local Notification scheduled for %@", localNotif.fireDate.description);
    }
    
    NSError *error;
    [[self managedObjectContext] save:&error];
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
