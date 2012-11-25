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
}
@property (retain, nonatomic) IBOutlet UITableView *userListTable;
@end
