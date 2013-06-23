//
//  HomeViewController.h
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSMutableArray* wordsCurrent;
@property (strong, nonatomic) NSMutableArray* wordsFinished;

@end
