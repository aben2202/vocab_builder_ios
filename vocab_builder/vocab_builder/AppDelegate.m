//
//  AppDelegate.m
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "AppDelegate.h"
#import "DictionaryObjectManager.h"
#import "MappingProvider.h"
#import "VocabBuilderDataModel.h"
#import "ReviewViewController.h"
#import "Global.h"
#import "HomeTableViewController.h"
#import "SettingsTableViewController.h"
#import "DefinitionViewController.h"
#import <FacebookSDK/FacebookSDK.h>

@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    self.dictionaryObjectManager = [DictionaryObjectManager managerWithBaseURL:[Global getInstance].dictionaryBaseURL];
    [[DictionaryObjectManager sharedManager].HTTPClient setDefaultHeader:@"api_key" value:@"e26ee69293d80e03b50040ada590aa0cc5a53f23105b45377"];
    
    [[VocabBuilderDataModel sharedDataModel] setup];
    
    [MappingProvider setupResponseAndRequestDescriptors];
    
    [Global getInstance].wordsThatNeedToBeReviewed = [NSMutableArray array];
    
    self.navController = (UINavigationController *)self.window.rootViewController;
        
    //check to see if they have any outstanding reviews
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    
    
    // if there are a lot of words in the app, the notifications further out in time will not be stored.  then when reviews are completed, they should be added again since they are now in the next 64.  so everytime they close the app, we will update the notifications
    [[Global getInstance] updateNotifications];
    
    // Let's update the current app icon badge and notifications badge numbers
    [[Global getInstance] setReviewWords];
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:[Global getInstance].wordsThatNeedToBeReviewed.count];
    NSInteger badgeNumber = [[UIApplication sharedApplication] applicationIconBadgeNumber];
    NSInteger count = 0;
    for (UILocalNotification *localNote in [[UIApplication sharedApplication] scheduledLocalNotifications]) {
        UILocalNotification *noteWithBadge = [[UILocalNotification alloc] init];
        noteWithBadge.fireDate = localNote.fireDate;
        noteWithBadge.alertAction = localNote.alertAction;
        noteWithBadge.alertBody = localNote.alertBody;
        noteWithBadge.soundName = localNote.soundName;
        badgeNumber = badgeNumber + 1;
        noteWithBadge.applicationIconBadgeNumber = badgeNumber;
        [[UIApplication sharedApplication] cancelLocalNotification:localNote];
        
        [[UIApplication sharedApplication] scheduleLocalNotification:noteWithBadge];
        NSLog(@"%d) Local Notification scheduled for %@ with badge number %d", count, noteWithBadge.fireDate.description, noteWithBadge.applicationIconBadgeNumber);
        count += 1;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    //Setup for facebook tracking... downloads and uses
    [FBSettings setDefaultAppID:@"502725236470731"];
    [FBAppEvents activateApp];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// Core Data Stuff
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
//    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"VocabBuilder" withExtension:@"momd"];
//    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

    NSString *momdPath = [[NSBundle mainBundle] pathForResource:@"VocabBuilder" ofType:@"momd"];
    NSURL *momURL = [NSURL fileURLWithPath:momdPath];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:momURL];
    
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"VocabBuilder.sqlite"];
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@YES, NSMigratePersistentStoresAutomaticallyOption,
                                                                       @YES, NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

-(void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification{
    // if they are already on the review screen, just do a refresh
    if ([self.navController.visibleViewController isKindOfClass:[ReviewViewController class]]) {
        ReviewViewController *currentReviewViewController = (ReviewViewController *)self.navController.visibleViewController;
        //[currentReviewViewController refresh];
    }
    else if ([self.navController.visibleViewController isKindOfClass:[HomeTableViewController class]]){
        HomeTableViewController *currentController = (HomeTableViewController *)self.navController.visibleViewController;
        [currentController performSegueWithIdentifier:@"reviewSegue" sender:self];
    }
    else if ([self.navController.visibleViewController isKindOfClass:[DefinitionViewController class]]){
        DefinitionViewController *currentController = (DefinitionViewController *)self.navController.visibleViewController;
        [currentController performSegueWithIdentifier:@"reviewSegue" sender:self];
    }
    else if ([self.navController.visibleViewController isKindOfClass:[SettingsTableViewController class]]){
        SettingsTableViewController *currentController = (SettingsTableViewController *)self.navController.visibleViewController;
        [currentController performSegueWithIdentifier:@"reviewSegue" sender:self];
    }
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}



@end
