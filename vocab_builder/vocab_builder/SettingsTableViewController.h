//
//  SettingsTableViewController.h
//  vocab_builder
//
//  Created by andebenson on 7/5/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsTableViewController : UITableViewController <UIAlertViewDelegate>

@property (strong, nonatomic) NSMutableArray *reviewSessions;
@property (strong, nonatomic) NSMutableArray *dictionaries;

- (IBAction)updateSession:(id)sender;
- (IBAction)updateDictionaries:(id)sender;

@end
