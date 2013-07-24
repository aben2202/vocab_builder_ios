//
//  ExampleUse.h
//  vocab_builder
//
//  Created by Andrew Benson on 7/24/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Entry;

@interface ExampleUse : NSManagedObject

@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) Entry *entry;

@end
