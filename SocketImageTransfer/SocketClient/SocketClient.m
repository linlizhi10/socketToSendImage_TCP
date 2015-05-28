//
//  SocketClient.m
//  SocketImageTransfer
//
//  Created by skunk  on 15/5/27.
//  Copyright (c) 2015年 linlizhi. All rights reserved.
//

#import "SocketClient.h"
/**
 *  while using socket ,should include these libraries
 *
 */
#import <stdlib.h>
#import <string.h>
#import <arpa/inet.h>
#import <stdio.h>
#import <unistd.h>
#import <sys/ioctl.h>
#import <sys/types.h>
#import <sys/socket.h>

@implementation SocketClient

- (BOOL)sendToServer:(UIImage *)image
{
    /**
     *  create socket
     *
     *  @param AF_INET     IP4 protocol
     *  @param SOCK_STREAM stream type of data while if use UDP ,it should be SOCK_DGRAM
     *  @param 0           0 for choosing fit protocol automatic
     *
     *  @return int
     */
    _socket = socket(AF_INET, SOCK_STREAM, 0);
    /**
     *  struct include detail message
     */
    struct sockaddr_in clientS;
    
    
    BOOL success = (_socket != -1);
    
    
    if (!success) {
        NSLog(@"failed to create");
    }else{
        /**
         *  clear
         */
        memset(&clientS, 0, sizeof(clientS));
        clientS.sin_family = AF_INET;
        clientS.sin_len = sizeof(clientS);
        clientS.sin_port = htons(8889);
        /**
         *  limit the the link destination
         *
         *  @param "192.168.0.78" change to your own IP
         *
         *  @return
         */
        clientS.sin_addr.s_addr = inet_addr("192.168.0.78");
        //inet_pton(AF_INET, "192.168.0.78", &clientS.sin_addr.s_addr);
        /**
         *  create a TCP Connect to keep connection, will't disConnect otherWise ask for break
         *  @return 
         */
        int connectSucess = connect(_socket, (struct sockaddr *)&clientS, clientS.sin_len);
        success = (connectSucess != -1);
        if (!success) {
            NSLog(@"failed to connect");
        }else{
            
            /**
             *  change image to data
             *
             *  @param image original Image
             *  @param 1.0f  quality of image
             *
             *  @return <#return value description#>
             */
            NSData *imageData = UIImageJPEGRepresentation(image, 1.0f);
            /**
             *  get image data's pointer
             *
             *  @param Byte dataImage.bytes pointer
             *
             *  @return *pData is content ,pData is address,pData+1 the second byte's address ,*(pData+1) is content in the address
             */
            Byte *pData = (Byte *)imageData.bytes;
            /**
             *  an object for data transfer
             */
            _FileDataS fileData;
            /**
             *  get data's length
             */
            fileData.fileLength = imageData.length;
            NSLog(@"fileLength is %ld",fileData.fileLength);
            /**
             *  name for fileName
             */
            memcpy(fileData.filename, "Pic01.jpg", sizeof("Pic01.jpg"));
            /**
             *  check whether the file is transfer finish or not
             */
            BOOL isFinish = NO;
            /**
             *  <#Description#>
             */
            int count = 0;
            /**
             *  transfer
             */
            do {
                /**
                 *  to check whether should send after this time
                 */
                if ((count + 1) * 1024 < fileData.fileLength) {
                    /**
                     *  intercept 1024 bytes from original data to fileData's fileBody
                     */
                    memcpy(fileData.filebody, pData + count * 1024, 1024);
                }
                /**
                 *  the last time to transfer,then all data tranfer successfully
                 */
                else{
                    memcpy(fileData.filebody, pData + count * 1024, fileData.fileLength - count * 1024);
                    isFinish = YES;
                }
                /**
                 *  send to server after 0.2f each time
                 */
                [NSThread sleepForTimeInterval:0.2f];
                
                ssize_t ret = send(_socket, &fileData, 1024, 0);
                
                if (ret > 0) {
                    /**
                     *  char		*inet_ntoa(struct in_addr);
                     */
                    NSLog(@"sucess to send to server:%s,port is %d",inet_ntoa(clientS.sin_addr),ntohs(clientS.sin_port));
                    
                }
                /**
                 *  while send failed skip to next
                 */
                count ++;
            } while (isFinish == NO );
            
            NSLog(@"send finished");
            /**
             *  close the socket pipe ,it will create four-way-handshake
             */
            close(_socket);
        }
    
    }
    
    return NO;
}
@end
