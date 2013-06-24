//
//  LoginViewController.h
//  vocab_builder
//
//  Created by Andrew Benson on 6/24/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CredentialStore.h"
#import "Global.h"

@interface LoginViewController : UIViewController

@property (strong, nonatomic) CredentialStore *credentialStore;
@property (strong, nonatomic) Global *globals;

@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;

- (IBAction)signInButtonClicked:(id)sender;

@end
