//
//  ViewController.m
//  SocketImageTransfer
//
//  Created by skunk  on 15/5/27.
//  Copyright (c) 2015年 linlizhi. All rights reserved.
//

#import "ViewController.h"
#import "SocketClient.h"
#import <stdio.h>
#import <stdlib.h>
#import <unistd.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <sys/socket.h>
#import <string.h>
@interface ViewController ()
/**
 *  image for sending
 */
@property (weak, nonatomic) IBOutlet UIImageView *readyToSendMessage;
/**
 *  send button
 */
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
/**
 *  send to server
 *
 *  @param sender button
 */
- (IBAction)sendToDestinationServer:(id)sender;

@property (nonatomic, retain) UIImageView *iView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _iView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"17_1.jpg"]];
    _iView.frame = CGRectMake(100, 100, 100, 100);
    [self.view addSubview:_iView];
    //_readyToSendMessage.image = [UIImage imageNamed:@"17_1.jpg"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendToDestinationServer:(id)sender {
    SocketClient *client = [[SocketClient alloc]init];
    [client sendToServer:_iView.image];
    //[client pressSend:_readyToSendMessage];
    
}


@end
