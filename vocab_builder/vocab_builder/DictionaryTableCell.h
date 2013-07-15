//
//  DictionaryTableCell.h
//  vocab_builder
//
//  Created by Andrew Benson on 7/15/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DictionaryTableCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *dictionaryNameLabel;
@property (weak, nonatomic) IBOutlet UISwitch *dictionarySwitch;

@end
