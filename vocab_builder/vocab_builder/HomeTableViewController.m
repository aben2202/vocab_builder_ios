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
#import "AppDelegate.h"
#import "Entry.h"

@interface HomeTableViewController ()

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
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"Word"
                inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSError *error;
    NSArray *words = [context executeFetchRequest:request error:&error];
    
    // create word objects from managed objects retrieved
    for (Word *currentWord in words) {
        // add word to correct array
        if (currentWord.finished == false) {
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
        cell.theWordLabel.text = cell.theWord.theWord;
    
        return cell;
    }
    else { // DoneAndDoneTableCell
        static NSString *CellIdentifier = @"DoneAndDoneTableCell";
        DoneAndDoneTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
        
        // Configure the cell...
        cell.theWord = [self.wordsFinished objectAtIndex:indexPath.row];
        cell.theWordLabel.text = cell.theWord.theWord;
        
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
        InTheWorksTableCell *cellClickedOn = [self.tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"showDefinition" sender:cellClickedOn];
    }
    else if (indexPath.section == 2) {
        // user clicked on 'done and done' word
        DoneAndDoneTableCell *cellClickedOn = [self.tableView cellForRowAtIndexPath:indexPath];
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
            
            // show definition view for searched word
            [self performSegueWithIdentifier:@"showDefinition" sender:searchBar];
            
        } failure:^(NSError *error) {
            // failure code goes here
            NSLog(error.localizedDescription);
        }];
    }
}

@end
