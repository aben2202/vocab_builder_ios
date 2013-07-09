//
//  DefinitionTableViewController.h
//  vocab_builder
//
//  Created by andebenson on 7/5/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"
#import "AppDelegate.h"

@interface DefinitionTableViewController : UITableViewController

@property (strong, nonatomic) Word *theWord;

@end
