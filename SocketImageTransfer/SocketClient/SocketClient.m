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
    //clientS.sin_addr.s_addr = inet_addr("192.168.0.78");
    inet_pton(AF_INET, "192.168.0.78", &clientS.sin_addr.s_addr);
    /**
     *  create a TCP Connect to keep connection, will't disConnect otherWise ask for break
     *  @return 
     */
    int connectSucess = connect(_socket, (struct sockaddr *)&clientS, clientS.sin_len);

    if (connectSucess == -1) {
        NSLog(@"failed to connect");
     }
    
    /**
     *  change image to data
     *
     *  @param image original Image
     *  @param 1.0f  quality of image
     *
     *  @return <#return value description#>
     */
    UIImage *image01 = image;
    NSData *imageData = UIImageJPEGRepresentation(image01, 1);
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
//    fileData.fileLength = imageData.length;
//    NSLog(@"fileLength is %ld",fileData.fileLength);
    /**
     *  name for fileName
     */
    //memcpy(fileData.filename, "file01.jpg", sizeof("file01.jpg"));
    /**
     *  check whether the file is transfer finish or not
     */
    BOOL isFinish = NO;
    /**
     *  send times
     */
    int count = 0;
    /**
     *  transfer
     */
//    ImageSTR imageS;
//    memcpy(imageS.image, pData, 22 * 1024);
//    int sendS = send(_socket, &imageS, sizeof(imageS), 0);
//    NSLog(@"sends is %d",sendS);
    do {
        /**
         *  to check whether should send after this time
         */
        if ((count + 1) * 1024 < imageData.length) {
            /**
             *  intercept 1024 bytes from original data to fileData's fileBody
             */
            memcpy(fileData.filebody, pData + count * 1024, 1024);
        }
        /**
         *  the last time to transfer,then all data tranfer successfully
         */
        else{
            memcpy(fileData.filebody, pData + count * 1024, imageData.length - count * 1024);
            NSLog(@"count is %d",count);
            isFinish = YES;
        }
        /**
         *  send to server after 0.2f each time caution size_t should be fileData 's length;
         */
        [NSThread sleepForTimeInterval:0.1f];
        
        ssize_t ret = send(_socket, &fileData, sizeof(fileData), 0);
        
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

    
    
    
    return YES;
}
/*
//基于TPC方式的数据连接发送
-(void) pressSend:(UIImageView *)imageView
{
    //创建基于TCP的socket(管道)对象
    _socket = socket(AF_INET,SOCK_STREAM,0);
    
    struct sockaddr_in server_add ;
    // 数据清零
    memset(&server_add, 0, sizeof(server_add)) ;
    
    server_add.sin_family = AF_INET ;
    server_add.sin_len = sizeof(server_add) ;
    server_add.sin_port = htons(8889) ;
    //
    //inet_pton(AF_INET, "192.168.81.208", &server_add.sin_addr.s_addr) ;
    inet_pton(AF_INET, "192.168.0.159", &server_add.sin_addr.s_addr);
    
    //创建一个TCP连接“对象”服务
    //创建一个长连接,保持管道的连续连接
    //没有请求断开时,连接要保持
    int connectR = connect(_socket, (struct sockaddr*)&server_add, server_add.sin_len) ;
    
    NSString* strFileName = @"file01.jpg" ;
    
    UIImage* image = imageView.image ;
    //将图像转化为二进制数据
    NSData* dataImage = UIImageJPEGRepresentation(image, 1) ;
    //获取图像二进制原始数据的指针
    //dataImage.bytes二进制数据指针地址
    //Byte：表示字节
    //pData表示第一个字节的地址
    //*pData第一个字节数据内容
    //pData+1 第二个字节的地址;
    //第二个字节的内容 *(pData+1)
    Byte* pData = (Byte*)dataImage.bytes ;
    
    //定义一个文件传输数据对象
    _FileDataS fileData ;
    
    //获取图像数据的大小
    //fileData.fileLength = dataImage.length ;
    //文件名赋值
    memcpy(fileData.filename, "file01.jpg", sizeof("file01.jpg"));
    
    //文件是否全部传输完毕
    BOOL isFinish = NO ;
    //第几次发送数据
    int count = 0 ;
    
    do
    {
        //表示此次发送数据后还需要继续发送
        if ( (count+1)*1024 < fileData.fileLength )
        {
            //从原始数据文件中截取1024个字节到fileBody中
            
            memcpy(fileData.filebody, pData+count*1024, 1024);
            
        }
        //这是最后一次发送,全部数据发送完成
        else
        {
            memcpy(fileData.filebody, pData+count*1024, fileData.fileLength-count*1024) ;
            isFinish = YES ;
        }
        
        //每发送一次,休眠0.2秒
        [NSThread sleepForTimeInterval:0.2] ;
        
        //发送到服务器端
        int ret = send(_socket, &fileData, sizeof(fileData), 0);
        if (ret >0) {
            NSLog(@"发送成功!");
        }
        
        count ++ ;
    }
    while (isFinish == NO);
    
    NSLog(@"发送结束");
}
*/
@end
