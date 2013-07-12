//
//  DoneAndDoneTableCell.h
//  vocab_builder
//
//  Created by andebenson on 7/4/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"

@interface DoneAndDoneTableCell : UITableViewCell

@property (strong, nonatomic) Word *theWord;
@property (weak, nonatomic) IBOutlet UILabel *theWordLabel;
@property (weak, nonatomic) IBOutlet UIButton *reviewAgainButton;
- (IBAction)reviewAgainButtonClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIImageView *letterImageView;

@end
