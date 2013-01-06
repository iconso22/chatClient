//
//  UsersConnectedViewController.h
//  chatClient
//
//  Created by Nicco on 11/25/12.
//  Copyright (c) 2012 Nicco. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UsersConnectedViewController : UIViewController<NSStreamDelegate,UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>{
    NSInputStream *inputStream;
    NSOutputStream *outputStream;
    NSMutableArray * messages;
    NSMutableArray *userList;
    int b;
}
@property (retain, nonatomic) IBOutlet UITableView *userListTable;
- (IBAction)reloadConnectedUser:(id)sender;
@property (retain, nonatomic) NSString *nickname;

@end
