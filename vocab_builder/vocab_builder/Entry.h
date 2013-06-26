//
//  Entry.h
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _WordType {
    WordTypeNoun        = 0,
    WordTypePronoun     = 1,
	WordTypeVerb        = 2,
	WordTypeAdverb      = 3,
    WordTypeAdjective   = 4,
    WordTypePreposition = 5
} WordType;

@interface Entry : NSObject

@property (strong, nonatomic) NSString *theWord;
@property (strong, nonatomic) NSString *pronunciationKey;
@property (strong, nonatomic) NSArray *definitions;
@property (strong, nonatomic) NSArray *synonyms;
@property (strong, nonatomic) NSArray *antonyms;
@property (strong, nonatomic) NSString *origin;
//@property (strong, nonatomic) NSNumber *firstUse;
@property (strong, nonatomic) NSArray *wordTypes;

@end
