//
//  Entry.h
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Entry : NSManagedObject

@property (strong, nonatomic) NSSet *textProns;
@property (strong, nonatomic) NSString *sourceDictionary;
@property (strong, nonatomic) NSSet *exampleUses;
@property (strong, nonatomic) NSSet *relatedWords;
@property (strong, nonatomic) NSSet *labels;
@property (strong, nonatomic) NSSet *citations;
@property (strong, nonatomic) NSString *word;
@property (strong, nonatomic) NSString *text;
@property (strong, nonatomic) NSString *sequence;
@property (strong, nonatomic) NSNumber *score;
@property (strong, nonatomic) NSString *partOfSpeech;
@property (strong, nonatomic) NSString *attributionText;

@end
