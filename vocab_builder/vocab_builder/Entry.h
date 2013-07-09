//
//  Entry.h
//  vocab_builder
//
//  Created by andebenson on 7/8/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Word;

@interface Entry : NSManagedObject

@property (nonatomic, retain) NSString * attributionText;
@property (nonatomic, retain) NSString * text;
@property (nonatomic, retain) NSString * partOfSpeech;
@property (nonatomic, retain) NSString * sourceDictionary;
@property (nonatomic, retain) NSString * word;
@property (nonatomic, retain) NSString * sequence;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSSet *textProns;
@property (nonatomic, retain) Word *wordRel;
@property (nonatomic, retain) NSSet *exampleUses;
@property (nonatomic, retain) NSSet *relatedWords;
@property (nonatomic, retain) NSSet *labels;
@property (nonatomic, retain) NSSet *citations;
@end

@interface Entry (CoreDataGeneratedAccessors)

- (void)addTextPronsObject:(NSManagedObject *)value;
- (void)removeTextPronsObject:(NSManagedObject *)value;
- (void)addTextProns:(NSSet *)values;
- (void)removeTextProns:(NSSet *)values;

- (void)addExampleUsesObject:(NSManagedObject *)value;
- (void)removeExampleUsesObject:(NSManagedObject *)value;
- (void)addExampleUses:(NSSet *)values;
- (void)removeExampleUses:(NSSet *)values;

- (void)addRelatedWordsObject:(NSManagedObject *)value;
- (void)removeRelatedWordsObject:(NSManagedObject *)value;
- (void)addRelatedWords:(NSSet *)values;
- (void)removeRelatedWords:(NSSet *)values;

- (void)addLabelsObject:(NSManagedObject *)value;
- (void)removeLabelsObject:(NSManagedObject *)value;
- (void)addLabels:(NSSet *)values;
- (void)removeLabels:(NSSet *)values;

- (void)addCitationsObject:(NSManagedObject *)value;
- (void)removeCitationsObject:(NSManagedObject *)value;
- (void)addCitations:(NSSet *)values;
- (void)removeCitations:(NSSet *)values;

@end
