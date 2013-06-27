//
//  LoginViewController.m
//  vocab_builder
//
//  Created by Andrew Benson on 6/24/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "LoginViewController.h"
#import "VocabBuilderObjectManager.h"
#import <SVProgressHUD/SVProgressHUD.h>
#import "LoginViewController.h"
#import "LoginCredentials.h"
#import "Session.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize credentialStore = _credentialStore;
@synthesize globals = _globals;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.globals = [Global getInstance];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if ([self.credentialStore isLoggedIn]) {
        //if logged in, get current user info and just segue to the app
        if (self.globals.currentUser == nil) {
            [[VocabBuilderObjectManager sharedManager].HTTPClient setDefaultHeader:@"Auth_token" value:[self.credentialStore authToken]];
            [self setCurrentUser];
        }
        else{
            [self performSegueWithIdentifier:@"toMainApp" sender:self];
        }
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)signInButtonClicked:(id)sender {
    [SVProgressHUD show];
    LoginCredentials *credentials = [[LoginCredentials alloc] init];
    credentials.email = self.emailTextField.text;
    credentials.password = self.passwordTextField.text;
    
    [[VocabBuilderObjectManager managerWithBaseURL:self.globals.vbBaseURL] signInWithCredentials:credentials withSuccess:^(Session *session) {
        NSLog(@"Successfully logged in!");
        self.globals.currentUser = session.current_user;
        NSString *auth_token = session.auth_token;
        [self.credentialStore setAuthToken:auth_token];
        [SVProgressHUD showSuccessWithStatus:@"Success"];
        [[VocabBuilderObjectManager managerWithBaseURL:self.globals.vbBaseURL].HTTPClient setDefaultHeader:@"Auth_token" value:[self.credentialStore authToken]];
        [self performSegueWithIdentifier:@"toMainApp" sender:self];
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"ERROR: %@", error);
        [SVProgressHUD showErrorWithStatus:@"Unable to login."];

    }];
}

-(void)setCurrentUser{
    [SVProgressHUD showWithStatus:@"Signing in..."];
    [[VocabBuilderObjectManager managerWithBaseURL:self.globals.vbBaseURL] getObjectsAtPath:@"users" parameters:@{@"auth_token":[self.credentialStore authToken]} success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        NSLog(@"Successfully retrieved current user!");
        User *newUser = mappingResult.array[0];
        self.globals.currentUser = newUser;
        [[VocabBuilderObjectManager managerWithBaseURL:self.globals.vbBaseURL].HTTPClient setDefaultHeader:@"Auth_token" value:[self.credentialStore authToken]];
        [self performSegueWithIdentifier:@"toMainApp" sender:self];
        [SVProgressHUD showSuccessWithStatus:@"Successfully logged in!"];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR: %@", error);
        NSLog(@"Response: %@", operation.HTTPRequestOperation.responseString);
        [SVProgressHUD showErrorWithStatus:@"Unable to login."];
    }];
}

-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if ([identifier isEqualToString:@"toMainApp"]) {
        if ([self.credentialStore isLoggedIn]) {
            return TRUE;
        }
        else{
            return FALSE;
        }
    }
    else{
        return TRUE;
    }
}

@end
