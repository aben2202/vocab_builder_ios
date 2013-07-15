//
//  Dictionary.h
//  vocab_builder
//
//  Created by Andrew Benson on 7/15/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Dictionary : NSManagedObject

@property (nonatomic, retain) NSString * wordnikString;
@property (nonatomic, retain) NSNumber * enabled;
@property (nonatomic, retain) NSString * humanString;

@end
