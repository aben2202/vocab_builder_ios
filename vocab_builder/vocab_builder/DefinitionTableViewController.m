//
//  DefinitionTableViewController.m
//  vocab_builder
//
//  Created by andebenson on 7/5/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "DefinitionTableViewController.h"
#import "TextViewTableCell.h"
#import "Entry.h"
#import "Global.h"

@interface DefinitionTableViewController ()

@end

@implementation DefinitionTableViewController

@synthesize theWord = _theWord;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    self.title = self.theWord.theWord;
    
    [self checkForReviews];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewWillAppear:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkForReviews{
    if ([[Global getInstance] wordsNeedToBeReviewed]) {
        [self performSegueWithIdentifier:@"reviewSegue" sender:self];
    }
}


-(NSString *)createDefinitionString:(NSSet *)entries{
    NSMutableArray *entriesArray = [NSMutableArray arrayWithArray:[entries allObjects]];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"text" ascending:YES];
    NSMutableArray *sortedEntries = [NSMutableArray arrayWithArray:[entriesArray sortedArrayUsingDescriptors:@[sortDesc]]];
    NSString *theText = @"";
    
    //first go through all the entries and find the different parts of speech
    for (Entry *entry in sortedEntries) {
        theText = [theText stringByAppendingString:[NSString stringWithFormat:@"- %@\n\n", entry.text]];
    }
    
    return theText;
}

#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"";
        case 1:
            return @"Synonyms";
        case 2:
            return @"Antonyms";
        default:
            return @"";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier;
    if (indexPath.section == 0) {
        CellIdentifier = @"DefinitionTableCell";
    }
    else if (indexPath.section == 1){
        CellIdentifier = @"SynonymsTableCell";
    }
    else if (indexPath.section == 2){
        CellIdentifier = @"AntonymsTableCell";
    }
    
    TextViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        //create the definition text
        cell.theTextView.text = [self createDefinitionString:self.theWord.entries];
    
    }
    else if (indexPath.section == 1){
        // create the synonyms text
        
    }
    else if (indexPath.section == 2){
        // create the antonyms text
    }
    
    cell.theTextView.editable = false;

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 250;
    }
    else {
        return 50;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

#pragma mark - Alert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"Review Time"]) { // it's a review alert
        if (buttonIndex == 0) {
            [[Global getInstance] setReviewWords];
            [self performSegueWithIdentifier:@"reviewSegue" sender:self];
        }
    }
}


@end
