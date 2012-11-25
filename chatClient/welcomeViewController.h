//
//  welcomeViewController.h
//  chatClient
//
//  Created by Nicco on 11/23/12.
//  Copyright (c) 2012 Nicco. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"

@interface welcomeViewController : UIViewController
- (IBAction)accedi:(id)sender;
@property (retain, nonatomic) IBOutlet UITextField *nicknameText;

@end
