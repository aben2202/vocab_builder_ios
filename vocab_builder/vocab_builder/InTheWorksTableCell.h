//
//  InTheWorksTableCell.h
//  vocab_builder
//
//  Created by andebenson on 7/4/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"

@interface InTheWorksTableCell : UITableViewCell

@property (strong, nonatomic) Word *theWord;
@property (weak, nonatomic) IBOutlet UILabel *theWordLabel;

@property (weak, nonatomic) IBOutlet UIProgressView *reviewProgressBar;
@property (weak, nonatomic) IBOutlet UILabel *reviewPercentageLabel;

@end
