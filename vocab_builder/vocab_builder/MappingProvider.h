//
//  MappingProvider.h
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface MappingProvider : NSObject

+ (RKObjectMapping *)userMapping;
+ (RKObjectMapping *)vocabBuilderWordMapping;
+ (RKObjectMapping *)merriamWebsterWordMapping;
+ (RKObjectMapping *)entryMapping;
+ (RKObjectMapping *)definitionMapping;

+ (void)setupResponseAndRequestDescriptors;

@end
