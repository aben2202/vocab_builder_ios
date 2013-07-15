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
#import "DefinitionTableCell.h"

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


-(NSString *)createDefinitionString:(Word *)word withDictionary:(NSString *)dictionaryName{
    NSMutableArray *entriesArray = [NSMutableArray arrayWithArray:[word.entries allObjects]];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    NSMutableArray *sortedEntries = [NSMutableArray arrayWithArray:[entriesArray sortedArrayUsingDescriptors:@[sortDesc]]];
    NSString *theText = @"<html><head><style>p.serif{font-family:'Times New Roman',Times,serif;} p.sansserif{font-family:Arial,Helvetica,sans-serif;}</style></head><body>";
    
    //first go through all the entries and find the different parts of speech
//    for (Entry *entry in sortedEntries) {
//        if (![[entry.text substringToIndex:8] isEqualToString:@"<strong>"] && entry.text != NULL && [dictionaryName isEqualToString:entry.sourceDictionary]) {
//            theText = [theText stringByAppendingString:@"- "];
//            if (![entry.partOfSpeech isEqualToString:@""] && entry.partOfSpeech != NULL) {
//                theText = [theText stringByAppendingString:[NSString stringWithFormat:@"%@. ", entry.partOfSpeech]];
//            }
//            theText = [theText stringByAppendingString:[NSString stringWithFormat:@"%@\n\n", entry.text]];
//        }
//    }

    
    // first we list the attribution text
    BOOL listedAttributionText = FALSE;
    for (Entry *entry in sortedEntries) {
        if (entry.text != NULL && [dictionaryName isEqualToString:entry.sourceDictionary]) {
            //add the dictionary attribution text if we have not already
            if (listedAttributionText == FALSE) {
                NSString *attrText = [NSString stringWithFormat:@"<p class='serif'><b>%@</b></p>", entry.attributionText];
                theText = [theText stringByAppendingString:attrText];
                listedAttributionText = TRUE;
            }
            theText = [theText stringByAppendingString:@"- "];
            if (![entry.partOfSpeech isEqualToString:@""] && entry.partOfSpeech != NULL) {
                theText = [theText stringByAppendingString:[NSString stringWithFormat:@"<i>%@</i>. ", entry.partOfSpeech]];
            }
            theText = [theText stringByAppendingString:[NSString stringWithFormat:@"%@<br><br>", entry.text]];
        }
    }

    theText = [theText stringByAppendingString:@"</p>"];
    
    return theText;
}

#pragma mark - Table view data source

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"Century Dictionary";
        case 1:
            return @"American Heritage Dictionary";
        case 2:
            return @"Synonyms";
        default:
            return @"";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
    //return 3;
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
        CellIdentifier = @"AHDTableCell";
    }
    
    //TextViewTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    DefinitionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    if (indexPath.section == 0) {
        //create the definition text
        //cell.theTextView.text = [self createDefinitionString:self.theWord.entries withDictionary:@"century"];
        
        [cell.webView loadHTMLString:[self createDefinitionString:self.theWord withDictionary:@"century"] baseURL:nil];
    
    }
//    else if (indexPath.section == 1){
//        cell.theTextView.text = [self createDefinitionString:self.theWord.entries withDictionary:@"ahd-legacy"];
//    }
//    else if (indexPath.section == 2){
//        // create the antonyms text
//    }
//    
//    cell.theTextView.editable = false;

    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 500;
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
