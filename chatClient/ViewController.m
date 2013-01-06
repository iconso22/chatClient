
#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize nicknameText,messageText,messagesTable,nickname,userListTable,a,textToolbar,serverAddress;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self initNetworkCommunication];
    messages = [[NSMutableArray alloc] init];
    [self login:nil];
     messagesTable.backgroundColor = [UIColor clearColor];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setNicknameText:nil];
    [self setMessageText:nil];
    [self setMessages:nil];
    [self setBackLogin:nil];
    [self setTextToolbar:nil];
    [super viewDidUnload];
}
- (IBAction)askUserList:(id)sender {
    [self requestUserList];
}

- (IBAction)SendMessage:(id)sender {
   //if I open and close the stream I can send only one message
    NSString *response  = [NSString stringWithFormat:@"msg~%@\n", messageText.text];
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
   
    [messageText setText:@""];
   
}

- (IBAction)login:(id)sender {
    NSString *response  = [NSString stringWithFormat:@"nick~%@\n", nickname];
	NSData *data = [[NSData alloc] initWithData:[response dataUsingEncoding:NSASCIIStringEncoding]];
	[outputStream write:[data bytes] maxLength:[data length]];
}

- (IBAction)backWelcomeView:(id)sender {
    [outputStream close];
    [inputStream close];
    [self dismissModalViewControllerAnimated:YES];
}

-(void)initNetworkCommunication{
    CFReadStreamRef *readStream;
    CFWriteStreamRef *writeStream;
    serverAddress=@"chat.iconsoapps.com";
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)serverAddress, 1234, &readStream, &writeStream);
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

- (void)dealloc {
    [super dealloc];
    [messages release];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"ChatCellIdentifier";
    
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }

    NSString *s = (NSString *) [messages objectAtIndex:indexPath.row];
    cell.textLabel.text = s;
    if([cell.textLabel.text rangeOfString:[NSString stringWithFormat:@"%@:",nickname]].location==NSNotFound||[cell.textLabel.text rangeOfString:[NSString stringWithFormat:@"%@: ",nickname]].location==NSNotFound ){ //messaggio inviato da altri cella di colore rossocell.contentView.backgroundColor=[UIColor redColor];
        cell.image=[UIImage imageNamed:@"Im-64.png"];
    }
    else{
        cell.image=[UIImage imageNamed:@"messages.png"];
    }
  	NSLog(cell.textLabel.text);
    NSString *myString = s;
    NSArray *myWords = [myString componentsSeparatedByCharactersInSet:
                        [NSCharacterSet characterSetWithCharactersInString:@":"]
                        ];
    NSLog([myWords objectAtIndex:0]);
    
    
    cell.detailTextLabel.text=[myWords objectAtIndex:0];
    cell.detailTextLabel.textColor=[UIColor whiteColor];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if([a intValue]==1){
            cell.textLabel.textColor=[UIColor whiteColor];
        }
        else{
            cell.textLabel.textColor=[UIColor blackColor];
        }
        
    }
    cell.accessoryType = UITableViewCellAccessoryNone;
    cell.userInteractionEnabled = NO;
        cell.textLabel.font = [UIFont fontWithName:@"Heiti TC Light"size:12 ];
       
	return cell;
    
    
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return messages.count;
}
-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        if([a intValue]==1){
            return 50;
        }
        else{
            return 50;
        }
    }
    else{
        return 50;
    }
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
- (void) messageReceived:(NSString *)message {
   	//se non c'e' un mittente, non visualizzare il messaggio perche' e' un messaggio del server, chiama interpretsServerMessage
  /*  if([message rangeOfString:@":"].location==NSNotFound){
        [self interpretsServerMessage:message];
        return;
    }*/
    
    [messages addObject:message];
	[self.messagesTable reloadData];
    if(messages.count>1){
        int lastRowNumber = [messagesTable numberOfRowsInSection:0] - 1;
        NSIndexPath* ip = [NSIndexPath indexPathForRow:lastRowNumber inSection:0];
        [messagesTable scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:NO];
    }

}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        [textField resignFirstResponder];
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f) {
                CGPoint a1=CGPointMake(160, 530);
                textToolbar.center=a1;
                //messagesTable.bounds=CGRectMake(0, 44, 320, 500);
                [messagesTable reloadData];
                
            } else {
                CGPoint a1=CGPointMake(160, 430);
                textToolbar.center=a1;
            }
        } else {
            /*Do iPad stuff here.*/
        }

       
        return YES;
    }
    [self SendMessage:nil];
    return NO;
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
        NSLog(@"User list:");
        for(NSString* key in a){
            [userList addObject:message];
            NSLog(@"%@",key);
        }
        
    }
}



- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone){
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            if (screenSize.height > 480.0f) {
                CGPoint a1=CGPointMake(160, 310);
                textToolbar.center=a1;
                
               // messagesTable.bounds=CGRectMake(0, 0, 320, screenSize.height-100);
                [messagesTable reloadData];
                             
            } else {
                CGPoint a1=CGPointMake(160, 223);
                textToolbar.center=a1;
            }
        } else {
            /*Do iPad stuff here.*/
        }
    
    }
}

@end
