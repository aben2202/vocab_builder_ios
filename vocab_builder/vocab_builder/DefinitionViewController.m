//
//  DefinitionViewController.m
//  vocab_builder
//
//  Created by Andrew Benson on 7/15/13.
//  Copyright (c) 2013 andebenson. All rights reserved.
//

#import "DefinitionViewController.h"
#import "Entry.h"
#import "Global.h"
#import "Dictionary.h"
#import "VocabBuilderDataModel.h"

@interface DefinitionViewController ()

@end

@implementation DefinitionViewController

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
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    
    self.title = self.theWord.theWord;
    [self checkForReviews];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(viewWillAppear:)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:nil];
    
    //load the webview string
    NSString *webviewString = @"<html><head><style>p.serif{font-family:'Times New Roman',Times,serif;} p.sansserif{font-family:Arial,Helvetica,sans-serif;}</style></head><body>";
    for (Dictionary *dict in [[VocabBuilderDataModel sharedDataModel] dictionaries]) {
        if ([dict.enabled boolValue]) {
            webviewString = [webviewString stringByAppendingString:[self createDefinitionString:self.theWord withDictionary:dict.wordnikString]];
        }
    }
    
    [self.webView loadHTMLString:webviewString baseURL:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)checkForReviews{
    if ([[Global getInstance] wordsNeedToBeReviewed]) {
        [self performSegueWithIdentifier:@"reviewSegue" sender:self];
    }
}


-(NSString *)createDefinitionString:(Word *)word withDictionary:(NSString *)dictionaryName{
    NSLog(@"Wordnik String: '%@'", dictionaryName);
    NSMutableArray *entriesArray = [NSMutableArray arrayWithArray:[word.entries allObjects]];
    NSSortDescriptor *sortDesc = [[NSSortDescriptor alloc] initWithKey:@"sequence" ascending:YES];
    NSMutableArray *sortedEntries = [NSMutableArray arrayWithArray:[entriesArray sortedArrayUsingDescriptors:@[sortDesc]]];
    NSString *theText = @"";
    
    BOOL listedAttributionText = FALSE;
    for (Entry *entry in sortedEntries) {
        NSLog(@"dictionaryName = %@", dictionaryName);
        NSLog(@"entry.sourceDictionary = %@", entry.sourceDictionary);
        if (entry.text != NULL && [dictionaryName isEqualToString:entry.sourceDictionary]) {
            //add the dictionary attribution text if we have not already
            if (listedAttributionText == FALSE) {
                NSString *attrText = [NSString stringWithFormat:@"<h3><p class='serif'><b>%@</b></p></h3>", entry.attributionText];
                theText = [theText stringByAppendingString:attrText];
                listedAttributionText = TRUE;
            }
            //add the dash mark at the beginning of each entry
            theText = [theText stringByAppendingString:@"- "];
            //add the part of speech first in italics
            if (![entry.partOfSpeech isEqualToString:@""] && entry.partOfSpeech != NULL) {
                theText = [theText stringByAppendingString:[NSString stringWithFormat:@"<i>%@</i>. ", entry.partOfSpeech]];
            }
            //add the entry text itself (the definition)
            theText = [theText stringByAppendingString:[NSString stringWithFormat:@"%@<br><br>", entry.text]];
        }
    }
    
    theText = [theText stringByAppendingString:@"</p></body>"];
    
    return theText;
}

#pragma mark - Alert View Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([alertView.title isEqualToString:@"Review Time"]) { // it's a review alert
        if (buttonIndex == 0) {
            [[Global getInstance] setReviewWords];
            [self performSegueWithIdentifier:@"reviewSegue" sender:self];
        }
    }
}



@end
