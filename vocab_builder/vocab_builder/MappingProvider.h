//
//  MappingProvider.h
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>
#import "Global.h"

@interface MappingProvider : NSObject

//+ (RKObjectMapping *)sessionMapping;
//+ (RKObjectMapping *)loginRequestMapping;
//+ (RKObjectMapping *)userMapping;
//+ (RKObjectMapping *)vocabBuilderWordMapping;

+ (RKEntityMapping *)entryMapping;


+ (void)setupResponseAndRequestDescriptors;

@end
