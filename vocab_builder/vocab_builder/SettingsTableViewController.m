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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewWillAppear:(BOOL)animated{
    [self loadReviewSessions];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)loadReviewSessions{
    [self.reviewSessions removeAllObjects];
    NSManagedObjectContext *context = [self managedObjectContext];
    
    NSEntityDescription *entityDesc = [NSEntityDescription entityForName:@"ReviewSession" inManagedObjectContext:context];
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"minutes" ascending:YES];
    [request setSortDescriptors:@[sortDesc]];
    
    NSError *error;
    NSMutableArray *sessions = [NSMutableArray arrayWithArray:[context executeFetchRequest:request error:&error]];
    
    //if this is the first time they load the app, the sessions will be blank.
    //  in this case we will create all the sessions now
    if(sessions.count == 0){
        self.reviewSessions = [self createInitialReviewSessions];
    }
    else{
        //save the fetched sessions to the TVC session property
        for(ReviewSession *session in sessions){
            [self.reviewSessions addObject:session];
        }
    }
}

-(NSMutableArray *)createInitialReviewSessions{
    NSMutableArray *sessions = [NSMutableArray array];
    NSArray *sessionStrings = @[@"15 minutes",
                                @"1 hour",
                                @"6 hours",
                                @"1 day",
                                @"3 days",
                                @"1 week",
                                @"2 weeks",
                                @"1 month",
                                @"2 months"];
    NSInteger day = 60*24;
    NSArray *sessionMinutes = @[@15,
                                @60,
                                @(60*6),
                                @(day),
                                @(day*3),
                                @(day*7),
                                @(day*14),
                                @(day*30),
                                @(day*61)];
    
    for (int i = 0; i < sessionStrings.count; i++){
        ReviewSession *newSession = [NSEntityDescription insertNewObjectForEntityForName:@"ReviewSession" inManagedObjectContext:[self managedObjectContext]];
        newSession.enabled = @true;
        newSession.timeName = [sessionStrings objectAtIndex:i];
        newSession.minutes = [sessionMinutes objectAtIndex:i];
        [sessions addObject:newSession];
    }
    NSError *error;
    [[self managedObjectContext] save:&error];
    return sessions;
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 9;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ReviewSessionTableCell";
    ReviewSessionTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    ReviewSession *theSession = [self.reviewSessions objectAtIndex:indexPath.row];
    cell.reviewTimeLabel.text = theSession.timeName;
    cell.sessionSwitch.tag = indexPath.row;
    cell.sessionSwitch.on = [theSession.enabled boolValue];
    
    return cell;
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

- (IBAction)updateSession:(id)sender {
    // this method gets called when a session.enabled status changes
    UISwitch *theSwitch = sender;
    
    // first figure out which session to update
    ReviewSession *sessionToUpdate = [self.reviewSessions objectAtIndex:theSwitch.tag];
    sessionToUpdate.enabled = [NSNumber numberWithBool:theSwitch.on];
    
    NSError *error;
    [[self managedObjectContext] save:&error];
}
@end
