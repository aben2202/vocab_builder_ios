//
//  HomeTableViewController.m
//  vocab_builder
//
//  Created by andebenson on 7/5/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "HomeTableViewController.h"
#import "InTheWorksTableCell.h"
#import "DoneAndDoneTableCell.h"
#import "SearchBarTableCell.h"
#import "DictionaryObjectManager.h"
#import "DefinitionTableViewController.h"
#import "Entry.h"
#import "ReviewSession.h"
#import "VocabBuilderDataModel.h"
#import "ReviewViewController.h"
#import "Global.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface HomeTableViewController ()

@property (strong, nonatomic) Word *wordToDelete;

@end

@implementation HomeTableViewController

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
    
    //load the managed objects from the database
    [self fetchData];
    [self.tableView reloadData];
    
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
    self.wordsCurrent = [NSMutableArray array];
    self.wordsFinished = [NSMutableArray array];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)checkForReviews{
    if ([[Global getInstance] wordsNeedToBeReviewed]) {
        [self performSegueWithIdentifier:@"reviewSegue" sender:self];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"showDefinition"]) {
        DefinitionTableViewController *defTVC = [segue destinationViewController];
        if ([sender isKindOfClass:[UISearchBar class]]) {
            //user searched for a word
            defTVC.theWord = self.searchedWord;
        }
        else if ([sender isKindOfClass:[InTheWorksTableCell class]]){
            //user clicked on a 'in the works' word
            InTheWorksTableCell *theSender = sender;
            defTVC.theWord = theSender.theWord;
        }
        else if ([sender isKindOfClass:[DoneAndDoneTableCell class]]){
            // user clicked on a 'done and done' word
            DoneAndDoneTableCell *theSender = sender;
            defTVC.theWord = theSender.theWord;
        }
        defTVC.title = defTVC.theWord.theWord;
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self resignFirstResponder];
}

-(void)fetchData{
    [self.wordsCurrent removeAllObjects];
    [self.wordsFinished removeAllObjects];
    
    // create word objects from managed objects retrieved
    for (Word *currentWord in [[VocabBuilderDataModel sharedDataModel] words]) {
        // add word to correct array
        if ([currentWord.finished boolValue] == false) {
            [self.wordsCurrent addObject:currentWord];
        }
        else {
            [self.wordsFinished addObject:currentWord];
        }
    }
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

-(NSString *)getFirstLetter:(NSString *)theWord{
    return [[theWord substringToIndex:1] uppercaseString];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    switch (section) {
        case 0:
            return 1;
        case 1: //"In the works" section
            return self.wordsCurrent.count;
        case 2: //"Done and done" section
            return self.wordsFinished.count;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) { // SearchBarTableCell
        static NSString *CellIdentifier = @"SearchBarTableCell";
        SearchBarTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        return cell;
    }
    else if (indexPath.section == 1){ // InTheWorksTableCell
        static NSString *CellIdentifier = @"InTheWorksTableCell";
        InTheWorksTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        cell.theWord = [self.wordsCurrent objectAtIndex:indexPath.row];
        cell.theWordLabel.text = [cell.theWord.theWord lowercaseString];
        cell.reviewProgressBar.progress = [[cell.theWord reviewProgress] floatValue];
        NSInteger percentageLabelNumber = ([[cell.theWord reviewProgress] floatValue] * 100);
        cell.reviewPercentageLabel.text = [NSString stringWithFormat:@"%d%%", percentageLabelNumber];
        
        NSLocale *locale = [NSLocale currentLocale];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        NSString *dateFormat = [NSDateFormatter dateFormatFromTemplate:@"MM/dd/yy" options:0 locale:locale];
        NSString *timeFormat = [NSDateFormatter dateFormatFromTemplate:@"hh/mm/ss" options:0 locale:locale];
        [formatter setDateFormat:dateFormat];
        [formatter setLocale:locale];
        cell.nextReviewDateLabel.text = [formatter stringFromDate:cell.theWord.nextReviewDate];
        [formatter setDateFormat:timeFormat];
        cell.nextReviewTimeLabel.text = [formatter stringFromDate:cell.theWord.nextReviewDate];
        NSString *firstLetter = [self getFirstLetter:cell.theWord.theWord];
        UIImage *letterImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", firstLetter]];
        [cell.letterImageView setImage:letterImage];
        
        // used while debugging
        [cell.nextReviewDateLabel setHidden:YES];
        [cell.nextReviewTimeLabel setHidden:YES];
    
        return cell;
    }
    else { // DoneAndDoneTableCell
        static NSString *CellIdentifier = @"DoneAndDoneTableCell";
        DoneAndDoneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        cell.theWord = [self.wordsFinished objectAtIndex:indexPath.row];
        cell.theWordLabel.text = [cell.theWord.theWord lowercaseString];
        cell.reviewAgainButton.tag = indexPath.row;
        NSString *firstLetter = [self getFirstLetter:cell.theWord.theWord];
        UIImage *letterImage = [UIImage imageNamed:[NSString stringWithFormat:@"%@.png", firstLetter]];
        [cell.letterImageView setImage:letterImage];
        
        return cell;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    switch (section) {
        case 0:
            return @"";
        case 1:
            return @"In the works...";
        case 2:
            return @"Done and done...";
        default:
            return @"";
    }
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        // user clicked on 'in the works' word
        InTheWorksTableCell *cellClickedOn = (InTheWorksTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"showDefinition" sender:cellClickedOn];
    }
    else if (indexPath.section == 2) {
        // user clicked on 'done and done' word
        DoneAndDoneTableCell *cellClickedOn = (DoneAndDoneTableCell *)[self.tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"showDefinition" sender:cellClickedOn];
    }
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0){
        return UITableViewCellEditingStyleNone;
    }
    else {
        return UITableViewCellEditingStyleDelete;
    }
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //if we are deleting a row, remove the word from the database
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        if (indexPath.section == 1) {  //we are deleting a 'in the works' word
            self.wordToDelete = [self.wordsCurrent objectAtIndex:indexPath.row];
        }
        else if (indexPath.section == 2){ // we are deleting a 'done and done' word
            self.wordToDelete = [self.wordsFinished objectAtIndex:indexPath.row];
        }
        UIAlertView *verifyDelete = [[UIAlertView alloc] initWithTitle:@"Delete Word?" message:[NSString stringWithFormat:@"Are you sure you want to delete the word '%@' and all its review data?", self.wordToDelete.theWord] delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
        [verifyDelete show];
    }
}

#pragma mark - Search bar delegate

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
   
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    NSString *wordString = searchBar.text;
    
    //first check if the searched word is already stored.
    BOOL wordAlreadyExists = false;
    for(Word *word in self.wordsCurrent){
        if([word.theWord isEqualToString:searchBar.text]){
            wordAlreadyExists = true;
            self.searchedWord = word;
            [self performSegueWithIdentifier:@"showDefinition" sender:searchBar];
            break;
        }
    }
    if (wordAlreadyExists == false){
        for (Word *word in self.wordsFinished){
            if([word.theWord isEqualToString:searchBar.text]){
                wordAlreadyExists = true;
                self.searchedWord = word;
                [self performSegueWithIdentifier:@"showDefinition" sender:searchBar];
                break;
            }
        }
    }
    
    //if word does not already exist, look it up using the wordnik api
    if (wordAlreadyExists == false){
    
        [[DictionaryObjectManager sharedManager] getWord:wordString withSuccess:^(Word *word) {
            self.searchedWord = word;
            
            // set alerts for new word
            [[Global getInstance] updateNotifications];
            
            // show definition view for searched word
            [self performSegueWithIdentifier:@"showDefinition" sender:searchBar];
            
        } failure:^(NSError *error) {
            // failure code goes here
            NSLog(@"%@", error.localizedDescription);
        }];
    }
}

#pragma mark - Alert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"Review Time"]) { // it's a review alert
        if (buttonIndex == 0) {
            [[Global getInstance] setReviewWords];
            [self performSegueWithIdentifier:@"reviewSegue" sender:self];
        }
    }
    else if ([alertView.title isEqualToString:@"Delete Word?"]){
        if (buttonIndex == 1) { // user clicked 'YES' to confirm deletion of the word
            NSManagedObjectContext *context = [self managedObjectContext];
            [context deleteObject:self.wordToDelete];
            NSError *error;
            [context save:&error];
            [[Global getInstance] updateNotifications];
            [self fetchData];
            [self.tableView reloadData];
        }
    }
}

- (IBAction)restartButtonClicked:(id)sender {
    UIButton *restartButton = sender;
    Word *wordToRestart = [self.wordsFinished objectAtIndex:restartButton.tag];
    NSLog(@"WordToRestart nextReviewSession = %@", wordToRestart.nextReviewSession.timeName);
    [wordToRestart resetReviewCycle];
    NSLog(@"WordToRestart nextReviewSession = %@", wordToRestart.nextReviewSession.timeName);

    
    NSError *errorMSG;
    [[self managedObjectContext] save:&errorMSG];
    
    [[Global getInstance] updateNotifications];
    [self fetchData];
    [self.tableView reloadData];
    [SVProgressHUD showSuccessWithStatus:@"Word Review Will Restart"];
}
@end
