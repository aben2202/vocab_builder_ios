//
//  ReviewViewController.h
//  vocab_builder
//
//  Created by andebenson on 7/9/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"
#import <GADBannerView.h>

@class GADBannerView, GADRequest;

@interface ReviewViewController : UIViewController <UIAlertViewDelegate, GADBannerViewDelegate>

@property (weak, nonatomic) NSArray *wordsToReview;
@property (weak, nonatomic) NSNumber *currentWordIndex;
@property (weak, nonatomic) IBOutlet UILabel *theWordLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UILabel *reviewNumberLabel;
@property (weak, nonatomic) IBOutlet UILabel *reviewSessionNameLabel;
@property (strong, nonatomic) GADBannerView *bannerView;
@property (weak, nonatomic) IBOutlet UIWebView *definitionWebView;
@property (weak, nonatomic) IBOutlet UIButton *showDefButton;
@property (weak, nonatomic) IBOutlet UILabel *wereYouCorrectLabel;
@property (weak, nonatomic) IBOutlet UILabel *noWillRestartLabel;
@property (weak, nonatomic) IBOutlet UIButton *infoButton;
@property (weak, nonatomic) IBOutlet UIImageView *defBorderImageView;

@property NSInteger thisReviewCountsAs;

- (IBAction)yesButtonClicked:(id)sender;
- (IBAction)noButtonClicked:(id)sender;
- (IBAction)infoButtonClicked:(id)sender;
- (void)refresh;
- (GADRequest *)createRequest;
- (IBAction)showDefClicked:(id)sender;

@end
