//
//  ViewController.h
//  chatClient
//
//  Created by Nicco on 11/23/12.
//  Copyright (c) 2012 Nicco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSStreamDelegate,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSMutableArray * messages;
    NSMutableArray *userList;
    

}
@property (retain, nonatomic) IBOutlet UIToolbar *textToolbar;
@property (strong, nonatomic) IBOutlet UITextField *nicknameText;
@property (retain, nonatomic) IBOutlet UITextField *messageText;
@property (retain, nonatomic) IBOutlet UITableView *messagesTable;
@property (retain, nonatomic) IBOutlet UITableView *userListTable;
@property (retain, nonatomic) NSNumber *a;
@property (retain, nonatomic) NSString *nickname;
@property (retain, nonatomic) NSString *serverAddress;
- (IBAction)askUserList:(id)sender;
- (IBAction)SendMessage:(id)sender;
- (IBAction)login:(id)sender;
- (IBAction)backWelcomeView:(id)sender;

@end
