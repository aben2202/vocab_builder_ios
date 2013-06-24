//
//  CredentialStore.h
//  vocab_builder
//
//  Created by Andrew Benson on 6/24/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CredentialStore : NSObject


-(BOOL)isLoggedIn;
-(void)clearSavedCredentails;
-(NSString *)authToken;
-(void)setAuthToken:(NSString *)authToken;

+(CredentialStore *)getInstance;

@end
