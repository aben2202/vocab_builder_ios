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
    [self refresh];
}

-(void)refresh{
    [[Global getInstance] setReviewWords];
    self.wordsToReview = [Global getInstance].wordsThatNeedToBeReviewed;
    [self reviewWordWithIndex:[[NSNumber numberWithInteger:0] integerValue]];
}

-(void)reviewWordWithIndex:(NSInteger)index{
    self.currentWordIndex = [NSNumber numberWithInteger:index];
    Word *wordToReview = [self.wordsToReview objectAtIndex:index];
    
    // first make sure the word we are reviewing has the nextReview set as the most recent enabled review in the past
    //   this will stop duplicates from occuring (two reviews right after one another when switching views).
    [wordToReview setNextReviewForMostRecentEnabledReview];
    
    self.title = [NSString stringWithFormat:@"Review %d of %d", index+1, self.wordsToReview.count];
    self.reviewNumber.text = [NSString stringWithFormat:@"%d", index + 1];
    self.reviewNumberTotal.text = [NSString stringWithFormat:@"%d", self.wordsToReview.count];
    self.reviewSessionNameLabel.text = [NSString stringWithFormat:@"'%@'", wordToReview.nextReviewSession.timeName];
    
    self.theWordLabel.text = wordToReview.theWord;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)yesButtonClicked:(id)sender {
    Word *wordToUpdate = [self.wordsToReview objectAtIndex:[self.currentWordIndex integerValue]];
    [wordToUpdate updateAfterCompletedReviewWithAnswer:YES];
    NSError *errorMSG;
    [[self managedObjectContext] save:&errorMSG];
    [SVProgressHUD showSuccessWithStatus:@"Nice Work!"];
    [self performNextReview];
}

- (IBAction)noButtonClicked:(id)sender {
    Word *wordToUpdate = [self.wordsToReview objectAtIndex:[self.currentWordIndex integerValue]];
    [wordToUpdate updateAfterCompletedReviewWithAnswer:NO];
    NSError *errorMSG;
    [[self managedObjectContext] save:&errorMSG];
    [SVProgressHUD showErrorWithStatus:@"You'll get it next time!"];
    [self performNextReview];
}

-(void)performNextReview{
    // check for another review
    if ([self.currentWordIndex integerValue] < self.wordsToReview.count - 1){
        [self reviewWordWithIndex:([self.currentWordIndex integerValue] +1)];
    }
    else{
        // save the context and dismiss view controller
        NSError *error;
        [[self managedObjectContext] save:&error];
        [self dismissViewControllerAnimated:YES completion:nil];
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

#pragma mark - alert view delegate

//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    if ([alertView.title isEqualToString:@"Reset Word"]) {
//        [self performNextReview];
//    }
//}

@end
