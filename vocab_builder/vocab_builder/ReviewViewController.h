//
//  ReviewViewController.h
//  vocab_builder
//
//  Created by andebenson on 7/9/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *theWordLabel;
@property (weak, nonatomic) IBOutlet UIButton *yesButton;
@property (weak, nonatomic) IBOutlet UIButton *noButton;

- (IBAction)yesButtonClicked:(id)sender;
- (IBAction)noButtonClicked:(id)sender;

@end
