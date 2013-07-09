//
//  Word.h
//  vocab_builder
//
//  Created by Andrew Benson on 6/26/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSManagedObject

@property (strong, nonatomic) NSString *theWord;
@property (strong, nonatomic) NSOrderedSet *entries;
@property (strong, nonatomic) NSSet *synonyms;
@property (strong, nonatomic) NSSet *antonyms;
@property (strong, nonatomic) NSDate *reviewCycleStart;
@property (strong, nonatomic) NSString *previousReview;
@property (strong, nonatomic) NSDate *nextReview;
@property  BOOL finished;

@end
