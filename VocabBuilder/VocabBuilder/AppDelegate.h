//
//  AppDelegate.h
//  VocabBuilder
//
//  Created by andebenson on 7/8/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DictionaryObjectManager.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (strong, nonatomic) DictionaryObjectManager *dictionaryObjectManager;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
