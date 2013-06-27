//
//  Word.h
//  vocab_builder
//
//  Created by Andrew Benson on 6/26/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Word : NSObject

@property (strong, nonatomic) NSNumber *wordId;
@property (strong, nonatomic) NSString *theWord;
@property (strong, nonatomic) NSArray *entries;
@property (strong, nonatomic) NSDate *reviewCycleStart;
@property (strong, nonatomic) NSDate *previousReview;
@property (strong, nonatomic) NSDate *nextReview;
@property  BOOL *finished;

@end
