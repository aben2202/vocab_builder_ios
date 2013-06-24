//
//  MappingProvider.m
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "MappingProvider.h"
#import "Word.h"
#import "Definition.h"

@implementation MappingProvider

+(RKObjectMapping *)wordMapping{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Word class]];
    [mapping addAttributeMappingsFromDictionary:@{@"entry[id]": @"theWord",
                                                  @"entry[pr]": @"pronunciationKey",
                                                  @"entry[fl]": @"wordTypes"
                                                  }];
    [mapping addRelationshipMappingWithSourceKeyPath:@"def" mapping:[self definitionMapping]];
    return mapping;
}

+(RKObjectMapping *)definitionMapping{
    RKObjectMapping *mapping = [RKObjectMapping mappingForClass:[Definition class]];
    [mapping addAttributeMappingsFromDictionary:@{@"date": @"firstUse",
                                                  @"sn": @"senseNumbers",
                                                  @"dt": @"definitions"}];
    return mapping;
}

+(void)setupResponseAndRequestDescriptors{
    NSIndexSet *statusCodeSet = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful);
    RKObjectManager *objectManager = [RKObjectManager sharedManager];
    
}
@end
