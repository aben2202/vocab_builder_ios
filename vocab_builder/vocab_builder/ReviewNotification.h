//
//  ReviewNotification.h
//  vocab_builder
//
//  Created by Andrew Benson on 7/9/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviewNotification : UILocalNotification

@property (strong, nonatomic) NSString *theWord;
@property (strong, nonatomic) NSString *reviewTimeString;

@end
