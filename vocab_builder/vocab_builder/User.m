//
//  User.m
//  vocab_builder
//
//  Created by andebenson on 6/24/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "User.h"
#import "Word.h"

@implementation User

@synthesize userId = _userId;
@synthesize email = _email;
@synthesize words = _words;
@synthesize currentWords = _currentWords;
@synthesize finishedWords = _finishedWords;


-(NSMutableArray *)currentWords{
    NSMutableArray *cWords = [NSMutableArray array];
    for (int i = 0; i < self.words.count; i++) {
        Word *thisIterWord = [self.words objectAtIndex:i];
        if (!thisIterWord.finished) {
            [cWords addObject:thisIterWord];
        }
    }
    return cWords;
}

-(NSMutableArray *)finishedWords{
    NSMutableArray *cWords = [NSMutableArray array];
    for (int i = 0; i < self.words.count; i++) {
        Word *thisIterWord = [self.words objectAtIndex:i];
        if (thisIterWord.finished) {
            [cWords addObject:thisIterWord];
        }
    }
    return cWords;
}

@end
