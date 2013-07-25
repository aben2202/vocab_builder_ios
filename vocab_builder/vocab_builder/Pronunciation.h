//
//  Pronunciation.h
//  vocab_builder
//
//  Created by Andrew Benson on 7/25/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Word;

@interface Pronunciation : NSManagedObject

@property (nonatomic, retain) NSNumber * seq;
@property (nonatomic, retain) NSString * rawType;
@property (nonatomic, retain) NSString * raw;
@property (nonatomic, retain) Word *word;

@end
