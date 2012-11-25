//
//  welcomeViewController.m
//  chatClient
//
//  Created by Nicco on 11/23/12.
//  Copyright (c) 2012 Nicco. All rights reserved.
//

#import "welcomeViewController.h"

@interface welcomeViewController ()

@end

@implementation welcomeViewController
@synthesize nicknameText;

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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)accedi:(id)sender {
    if (nicknameText.text==NULL) {
        return;
    }
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
         ViewController *a=[[UIStoryboard storyboardWithName:@"MainStoryboard_iPad" bundle:nil] instantiateViewControllerWithIdentifier:@"1"];
        a.nickname=nicknameText.text;
        a.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        [self presentModalViewController:a animated:YES];
    }
    else{
        ViewController *a=[[UIStoryboard storyboardWithName:@"MainStoryboard_iPhone" bundle:nil] instantiateViewControllerWithIdentifier:@"1"];
        a.nickname=nicknameText.text;
        a.modalTransitionStyle=UIModalTransitionStyleFlipHorizontal;
        NSNumber *b=[NSNumber numberWithInt:1];
        a.a=b;
        [self presentModalViewController:a animated:YES];
    }
   
    
}
- (void)dealloc {
    
    [super dealloc];
}
- (void)viewDidUnload {
    [self setNickname:nil];
    [super viewDidUnload];
}
-(IBAction)textFieldDoneEditing:(id)sender{
	[sender resignFirstResponder];
}
@end
