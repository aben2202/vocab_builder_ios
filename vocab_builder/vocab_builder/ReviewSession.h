//
//  ReviewSession.h
//  vocab_builder
//
//  Created by andebenson on 7/9/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface ReviewSession : NSManagedObject

@property (nonatomic, retain) NSString * timeName;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSNumber * minutes;

@end
