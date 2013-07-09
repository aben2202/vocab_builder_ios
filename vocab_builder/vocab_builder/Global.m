//
//  Global.m
//  vocab_builder
//
//  Created by Andrew Benson on 6/24/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "Global.h"

@implementation Global

@synthesize dictionaryBaseURL = _dictionaryBaseURL;
@synthesize currentUser = _currentUser;

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




@end
