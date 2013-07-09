//
//  InTheWorksTableCell.m
//  vocab_builder
//
//  Created by andebenson on 7/4/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "InTheWorksTableCell.h"

@implementation InTheWorksTableCell

@synthesize theWordLabel = _theWordLabel;
@synthesize reviewProgressBar = _reviewProgressBar;
@synthesize reviewPercentageLabel = _reviewPercentageLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
