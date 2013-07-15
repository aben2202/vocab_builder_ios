//
//  DictionaryTableCell.m
//  vocab_builder
//
//  Created by Andrew Benson on 7/15/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "DictionaryTableCell.h"

@implementation DictionaryTableCell

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
