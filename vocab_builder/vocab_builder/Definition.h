//
//  Definition.h
//  vocab_builder
//
//  Created by andebenson on 6/24/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Definition : NSObject

@property (strong, nonatomic) NSString *firstUse;
@property (strong, nonatomic) NSArray *definitions;
@property (strong, nonatomic) NSArray *senseNumbers;

@end
