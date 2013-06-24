//
//  AppDelegate.h
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VocabBuilderObjectManager.h"
#import "MerriamWebsterObjectManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) VocabBuilderObjectManager *vbObjectManager;
@property (retain, nonatomic) MerriamWebsterObjectManager *mwObjectManager;

@end
