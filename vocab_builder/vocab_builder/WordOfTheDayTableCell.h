//
//  WordOfTheDayTableCell.h
//  vocab_builder
//
//  Created by Andrew Benson on 10/31/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WordOfTheDayTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *WODLabel;
@property (weak, nonatomic) IBOutlet UIButton *WODAddToListButton;
@property (weak, nonatomic) IBOutlet UIImageView *WODFirstLetterImage;

@end
