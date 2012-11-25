<img src="http://acer.custhelp.com/euf/rightnow/optimized/1353412097/themes/standard/images/acer/chat.jpg" alt="chatClient" title="chatClient" style="display:block; margin: 10px auto 30px auto;" class="center">

chatClient is a delightful chat client written for iOS. It's built on top of [NSStream](https://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSStream_Class/Reference/Reference.html).
For example, here's how to connect to the server:

``` objective-c
-(void)initNetworkCommunication{
    CFReadStreamRef *readStream;
    CFWriteStreamRef *writeStream;
    CFStreamCreatePairWithSocketToHost(NULL, (CFStringRef)@"home.unname.eu", 1234, &readStream, &writeStream);
    inputStream=(NSInputStream *)readStream;
    outputStream=(NSOutputStream *)writeStream;
    [inputStream setDelegate:self];
    [outputStream setDelegate:self];
    //mi creo il ciclo che mi permette di controllare se ci sono dati da ricevere o da inviare, per avere le notifiche
    [inputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [outputStream scheduleInRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
    [inputStream open];
    [outputStream open];
}```

## How To Get Started

- [Download chatClient](https://github.com/iconso22/chatClient/master) and try to run the iPhone app
- To change the server or the port edit the method initWithNetworkCommunication in the ViewController.m file
- Insert a nickname
- Enjoy!
