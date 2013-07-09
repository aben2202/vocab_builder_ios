//
//  ReviewSessionTableCell.h
//  vocab_builder
//
//  Created by andebenson on 7/5/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewSessionTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *reviewTimeLabel;
@property (weak, nonatomic) IBOutlet UISwitch *sessionSwitch;

@end