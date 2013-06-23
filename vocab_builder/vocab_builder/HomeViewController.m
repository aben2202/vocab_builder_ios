//
//  HomeViewController.m
//  vocab_builder
//
//  Created by andebenson on 6/23/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "HomeViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma tableview datasource methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
    return @[@"In the works...", @"Done and done..."];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    switch (section) {
        case 0: //"In the works" section
            return self.wordsCurrent.count;
        case 1: //"Done and done" section
            return self.wordsFinished.count;
        default:
            break;
    }
    return 0;
}

@end
