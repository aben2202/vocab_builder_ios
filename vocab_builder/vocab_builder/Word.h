//
//  Word.h
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _WordType {
    WordTypeNoun        = 0,
	WordTypeVerb        = 1,
	WordTypeAdverb      = 2,
    WordTypeAdjective   = 3,
    WordTypePronoun     = 4,
    WordTypePreposition = 5
} WordType;

@interface Word : NSObject

@property (strong, nonatomic) NSString *theWord;
@property (strong, nonatomic) NSString *definition;
@property (strong, nonatomic) NSArray *synonyms;
@property (strong, nonatomic) NSArray *antonyms;
@property (strong, nonatomic) NSString *origin;
@property (strong, nonatomic) NSNumber *firstUse;
@property (strong, nonatomic) NSString *wordType;

@end
