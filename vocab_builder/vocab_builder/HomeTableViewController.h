//
//  HomeTableViewController.h
//  vocab_builder
//
//  Created by andebenson on 7/5/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"

@interface HomeTableViewController : UITableViewController <UISearchBarDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) Word *searchedWord;

@property (strong, nonatomic) NSMutableArray* wordsCurrent;
@property (strong, nonatomic) NSMutableArray* wordsFinished;

- (IBAction)restartButtonClicked:(id)sender;

@end
