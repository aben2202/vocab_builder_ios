//
//  ReviewViewController.h
//  vocab_builder
//
//  Created by andebenson on 7/9/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"

@interface ReviewViewController : UIViewController <UIAlertViewDelegate>

@property (weak, nonatomic) NSArray *wordsToReview;
@property (weak, nonatomic) NSNumber *currentWordIndex;
@property (weak, nonatomic) IBOutlet UILabel *theWordLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;
@property (weak, nonatomic) IBOutlet UILabel *reviewNumber;
@property (weak, nonatomic) IBOutlet UILabel *reviewNumberTotal;
@property (weak, nonatomic) IBOutlet UILabel *reviewSessionNameLabel;

- (IBAction)yesButtonClicked:(id)sender;
- (IBAction)noButtonClicked:(id)sender;
- (void)refresh;

@end
