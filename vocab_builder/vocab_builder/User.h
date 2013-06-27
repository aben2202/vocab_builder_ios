//
//  User.h
//  vocab_builder
//
//  Created by andebenson on 6/24/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface User : NSObject

@property (strong, nonatomic) NSNumber *userId;
@property (strong, nonatomic) NSString *email;
@property (strong, nonatomic) NSMutableArray *words;
@property (strong, nonatomic) NSMutableArray *currentWords;
@property (strong, nonatomic) NSMutableArray *finishedWords;

@end
