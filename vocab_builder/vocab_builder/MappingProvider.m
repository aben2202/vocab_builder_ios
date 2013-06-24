//
//  MappingProvider.m
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "MappingProvider.h"
#import "Word.h"

@implementation MappingProvider

+(RKObjectMapping *)wordMapping{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Word class]];
    [mapping addAttributeMappingsFromDictionary:@{@"definition":@"definition"}];
    return mapping;
}

+(void)setupResponseAndRequestDescriptors{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
}
@end
