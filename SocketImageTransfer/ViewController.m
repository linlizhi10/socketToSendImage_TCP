//
//  ViewController.m
//  SocketImageTransfer
//
//  Created by skunk  on 15/5/27.
//  Copyright (c) 2015年 linlizhi. All rights reserved.
//

#import "ViewController.h"

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

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendToDestinationServer:(id)sender {
}
@end
