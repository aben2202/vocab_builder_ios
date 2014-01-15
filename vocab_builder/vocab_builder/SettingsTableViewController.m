//
//  SettingsTableViewController.m
//  vocab_builder
//
//  Created by andebenson on 7/5/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "SettingsTableViewController.h"
#import "ReviewSession.h"
#import "ReviewSessionTableCell.h"
#import "Word.h"
#import "VocabBuilderDataModel.h"
#import "Global.h"
#import "DictionaryTableCell.h"
#import "Dictionary.h"

@interface SettingsTableViewController ()

@end

@implementation SettingsTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.reviewSessions = [NSMutableArray array];
    self.dictionaries = [NSMutableArray array];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    self.reviewSessions = [[VocabBuilderDataModel sharedDataModel] reviewSessions];
    self.dictionaries = [[VocabBuilderDataModel sharedDataModel] dictionaries];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSManagedObjectContext *)managedObjectContext
{
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}

- (IBAction)updateSession:(id)sender {
    // this method gets called when a session.enabled status changes
    UISwitch *theSwitch = sender;
    
    // first figure out which session to update
    ReviewSession *sessionToUpdate = [self.reviewSessions objectAtIndex:theSwitch.tag];
    //sessionToUpdate.enabled = [NSNumber numberWithBool:theSwitch.on];
    [sessionToUpdate setValue:[NSNumber numberWithBool:theSwitch.on] forKey:@"enabled"];
    
    NSError *error;
    [[self managedObjectContext] save:&error];
    
    // update next reviews and notifications
    [self updateNextReviews];
    [[Global getInstance] updateNotifications];
}

- (IBAction)updateDictionaries:(id)sender {
    UISwitch *theSwitch = sender;
    Dictionary *dictToUpdate = [self.dictionaries objectAtIndex:theSwitch.tag];
    [dictToUpdate setValue:[NSNumber numberWithBool:theSwitch.on] forKey:@"enabled"];
    
    NSError *error;
    [[self managedObjectContext] save:&error];
}

-(void)updateNextReviews{
    //NSArray *reviewSessions = [[VocabBuilderDataModel sharedDataModel] reviewSessions];
    
    for (Word *word in [[VocabBuilderDataModel sharedDataModel] words]) {
        [word updateNextReviewSession];
    }
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            //subtract 1 for the 'start' session
            return [[VocabBuilderDataModel sharedDataModel] reviewSessions].count - 1;
        case 1:
            return 5;
        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *cellIdentifier = @"ReviewSessionTableCell";
        ReviewSessionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        ReviewSession *theSession = [self.reviewSessions objectAtIndex:indexPath.row + 1];
        cell.reviewTimeLabel.text = theSession.timeName;
        cell.sessionSwitch.tag = indexPath.row + 1; //we add 1 since we are not displaying the 'start' session in the table
        cell.sessionSwitch.on = [theSession.enabled boolValue];
        
        return cell;
    }
    else if (indexPath.section == 1){
        NSString *cellIdentifier = @"DictionaryTableCell";
        DictionaryTableCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        // Configure the cell...
        Dictionary *theDict = [self.dictionaries objectAtIndex:indexPath.row];
        cell.dictionaryNameLabel.text = theDict.humanString;
        cell.dictionarySwitch.tag = indexPath.row; 
        cell.dictionarySwitch.on = [theDict.enabled boolValue];
        
        return cell;
    }
    else{
        return NULL;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Review Sessions";
        case 1:
            return @"Dictionaries";
        default:
            return @"";
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
