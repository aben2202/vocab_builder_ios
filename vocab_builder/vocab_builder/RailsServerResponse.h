//
//  RailsServerResponse.h
//  vocab_builder
//
//  Created by Andrew Benson on 10/17/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RailsServerResponse : NSObject

@property (nonatomic, retain) NSString *word;
@property (nonatomic, retain) NSNumber *occurances;

@end
