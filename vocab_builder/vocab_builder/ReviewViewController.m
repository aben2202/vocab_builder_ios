//
//  ReviewViewController.m
//  vocab_builder
//
//  Created by andebenson on 7/9/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "ReviewViewController.h"
#import "ReviewSession.h"
#import "Global.h"
#import <SVProgressHUD/SVProgressHUD.h>

@interface ReviewViewController ()

@end

@implementation ReviewViewController

@synthesize thisReviewCountsAs = _thisReviewCountsAs;
@synthesize bannerView = _bannerView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    //[self refresh];
}

-(void)viewWillAppear:(BOOL)animated{
    [self refresh];
}

-(void)setupAdmob{
    self.bannerView = [[GADBannerView alloc] initWithFrame:CGRectMake(0.0,
                                                                      self.view.frame.size.height,
                                                                      GAD_SIZE_320x50.width,
                                                                      GAD_SIZE_320x50.height)];
    self.bannerView.adUnitID = @"a151e56e545b57b";
    self.bannerView.delegate = self;
    [self.bannerView setRootViewController:self];
    [self.view addSubview:self.bannerView];
    [self.bannerView loadRequest:[self createRequest]];
}

-(GADRequest *)createRequest{
    GADRequest *request = [GADRequest request];
    
    //for test adds on my device
    request.testDevices = [NSArray arrayWithObjects:@"5d5cf0c15383488a857a24046b7d0abc", nil];
    
    //for test adds on simulator
    //request.testDevices = [NSArray arrayWithObjects:@"GAD_SIMULATOR_ID", nil];
    
    return request;
}

-(void)refresh{
    [[Global getInstance] setReviewWords];
    self.wordsToReview = [Global getInstance].wordsThatNeedToBeReviewed;
    [self reviewWordWithIndex:[[NSNumber numberWithInteger:0] integerValue]];
}

-(void)reviewWordWithIndex:(NSInteger)index{
    self.currentWordIndex = [NSNumber numberWithInteger:index];
    [self setupAdmob];
    [self setupInitialLayout];
    Word *wordToReview = [self.wordsToReview objectAtIndex:index];
    
    
    // first make sure the word we are reviewing has the nextReview set as the most recent enabled review in the past
    //   this will stop duplicates from occuring (two reviews right after one another when switching views).
    self.thisReviewCountsAs = [wordToReview setNextReviewForMostRecentEnabledReview];
    
    self.title = [NSString stringWithFormat:@"Review %d of %d", index+1, self.wordsToReview.count];
    self.reviewNumberLabel.text = [NSString stringWithFormat:@"%d of %d", index + 1, self.wordsToReview.count];
    self.reviewSessionNameLabel.text = [NSString stringWithFormat:@"'%@'", wordToReview.nextReviewSession.timeName];
    
    self.theWordLabel.text = wordToReview.theWord;
    [self.definitionWebView loadHTMLString:[wordToReview htmlDefinitionString] baseURL:nil];
}

-(void)setupInitialLayout{
    self.definitionWebView.hidden = true;
    self.showDefButton.hidden = false;
    self.yesButton.hidden = true;
    self.noButton.hidden = true;
    self.wereYouCorrectLabel.hidden = true;
    self.noWillRestartLabel.hidden = true;
}

-(void)setupDefinitionLayout{
    self.definitionWebView.hidden = false;
    self.showDefButton.hidden = true;
    self.yesButton.hidden = false;
    self.noButton.hidden = false;
    self.wereYouCorrectLabel.hidden = false;
    self.noWillRestartLabel.hidden = false;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showDefClicked:(id)sender {
    [self setupDefinitionLayout];
}

- (IBAction)yesButtonClicked:(id)sender {
    Word *wordToUpdate = [self.wordsToReview objectAtIndex:[self.currentWordIndex integerValue]];
    [wordToUpdate updateAfterCompletedReviewWithAnswer:YES];
    [SVProgressHUD showSuccessWithStatus:@"Nice Work!"];
    [self performNextReview];
}

- (IBAction)noButtonClicked:(id)sender {
    Word *wordToUpdate = [self.wordsToReview objectAtIndex:[self.currentWordIndex integerValue]];
    [wordToUpdate updateAfterCompletedReviewWithAnswer:NO];
    [SVProgressHUD showErrorWithStatus:@"You'll get it next time!"];
    [[Global getInstance] updateNotificationsForWord:wordToUpdate];
    [self performNextReview];
}

-(void)performNextReview{
    // check for another review
    if ([self.currentWordIndex integerValue] < self.wordsToReview.count - 1){
        [UIApplication sharedApplication].applicationIconBadgeNumber = [UIApplication sharedApplication].applicationIconBadgeNumber - self.thisReviewCountsAs;
        
        // we need to update the notfications beacuse the badge numbers will all need to be updated
        //  (this takes too long to do, so we just do it for a 'no' response and after all reviews are finished)
        
        [self reviewWordWithIndex:([self.currentWordIndex integerValue] +1)];
    }
    else{
        // save the context and dismiss view controller
        NSError *error;
        [[self managedObjectContext] save:&error];
        [self dismissViewControllerAnimated:YES completion:nil];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
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

#pragma mark - admob banner view delegate methods
-(void)adViewDidReceiveAd:(GADBannerView *)view{
    NSLog(@"Received ad");
    
    [UIView animateWithDuration:1.0 animations:^{
        view.frame = CGRectMake(0.0, self.view.frame.size.height - view.frame.size.height, view.frame.size.width, view.frame.size.height);
    }];
}

-(void)adView:(GADBannerView *)view didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"Unable to load ad with error: %@", [error localizedDescription]);
}


#pragma mark - alert view delegate

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if ([alertView.title isEqualToString:@"Reset Word"]) {
//        [self performNextReview];
//    }
//}

@end
