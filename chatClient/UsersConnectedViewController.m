//
//  UsersConnectedViewController.m
//  chatClient
//
//  Created by Nicco on 11/25/12.
//  Copyright (c) 2012 Nicco. All rights reserved.
//This class will allow users to chat directly with the others
//I will have to add the apple notification service

#import "UsersConnectedViewController.h"

@interface UsersConnectedViewController ()

@end

@implementation UsersConnectedViewController
@synthesize nickname,userListTable;
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
    [self initNetworkCommunication];
    [self loginWithNicknameUser];
    [self requestUserList];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)stream:(NSStream *)theStream handleEvent:(NSStreamEvent)streamEvent {
	switch (streamEvent) {
            
		case NSStreamEventOpenCompleted:
			NSLog(@"Stream opened");
			break;
            
		case NSStreamEventHasBytesAvailable:
            if (theStream == inputStream) {
                
                uint8_t buffer[1024];
                int len;
                
                while ([inputStream hasBytesAvailable]) {
                    len = [inputStream read:buffer maxLength:sizeof(buffer)];
                    if (len > 0) {
                        
                        NSString *output = [[NSString alloc] initWithBytes:buffer length:len encoding:NSASCIIStringEncoding];
                        
                        if (nil != output) {
                            NSLog(@"server said: %@", output);
                            [self messageReceived:output];
                        }
                    }
                }
            }
			break;
            
		case NSStreamEventErrorOccurred:
			NSLog(@"Can not connect to the host!");
            
			break;
            
		case NSStreamEventEndEncountered:
			break;
            
		default:{
            NSLog(@"Unknown event");
        }
	}
    
}

-(void)initNetworkCommunication{
    CFReadStreamRef *readStream;
    CFWriteStreamRef *writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"chat.iconsoapps.com", 1234, &readStream, &writeStream);
    inputStream=(NSInputStream *)readStream;
    outputStream=(NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    //mi creo il ciclo che mi permette di controllare se ci sono dati da ricevere o da inviare, per avere le notifiche
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}

- (void) messageReceived:(NSString *)message {
   	//se non c'e' un mittente, non visualizzare il messaggio perche' e' un messaggio del server, chiama interpretsServerMessage
    if([message rangeOfString:@":"].location==NSNotFound){
        [self interpretsServerMessage:message];
        return;
    }
}

- (IBAction)login:(id)sender {
    NSString *response  = [NSString stringWithFormat:@"nick~%@\n", nickname];
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
}

-(void)requestUserList{
    NSString *response  = @"getusr\n";
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
}

-(void)interpretsServerMessage:(NSString *)message{
    NSLog(@"messaggio del server: '%@'",message);
    if([message hasPrefix:@"~"]){ //allora sto ricevendo la lista degli utenti connessi
        NSArray *a=[message componentsSeparatedByString:@"~"];
        NSLog(@"User list: ");
        for(NSString* key in a){
                NSLog(@"%@",key);
            
        }
        userList=[[NSMutableArray alloc]initWithArray:a];
        [userList removeObjectAtIndex:0];
        [self.userListTable reloadData];
    }
}

#pragma mark - Table View connected users
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ChatCellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    NSString *s = (NSString *) [userList objectAtIndex:indexPath.row];
    cell.textLabel.text = s;
    
    if([cell.textLabel.text rangeOfString:[NSString stringWithFormat:@"User"]].location==NSNotFound||[cell.textLabel.text rangeOfString:[NSString stringWithFormat:@"null"]].location==NSNotFound){
        cell.image=[UIImage imageNamed:@"accountGrey.PNG"];
    }
    else{
        cell.image=[UIImage imageNamed:@"accountOrange.PNG"];
    }
      	
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        
    }
	return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return userList.count;
}

-(void)loginWithNicknameUser{
    NSString *response  = @"nick~User\n";
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
}



- (IBAction)reloadConnectedUser:(id)sender {
    [self requestUserList];
}
@end
