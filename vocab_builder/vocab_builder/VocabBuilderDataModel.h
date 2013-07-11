//
//  VocabBuilderDataModel.h
//  vocab_builder
//
//  Created by andebenson on 7/7/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RestKit/RestKit.h>

@interface VocabBuilderDataModel : NSObject

@property (nonatomic, strong) RKManagedObjectStore *objectStore;
@property (strong, nonatomic) NSSet *words;
@property (strong, nonatomic) NSSet *reviewSessions;

+ (id)sharedDataModel;
-(void)setup;

@end
