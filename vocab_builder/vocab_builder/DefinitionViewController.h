//
//  DefinitionViewController.h
//  vocab_builder
//
//  Created by Andrew Benson on 7/15/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Word.h"

@interface DefinitionViewController : UIViewController <UIAlertViewDelegate>

@property (strong, nonatomic) Word *theWord;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end
