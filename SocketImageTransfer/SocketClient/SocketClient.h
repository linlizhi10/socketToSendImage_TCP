//
//  SocketClient.h
//  SocketImageTransfer
//
//  Created by skunk  on 15/5/27.
//  Copyright (c) 2015年 linlizhi. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  define a struct for networking transfer
 */
typedef struct fileData
{
    
    char filename[128] ;
    Byte filebody[1024] ;
    unsigned long  fileLength ;
}
_FileDataS
;
@interface SocketClient : NSObject
{
    /**
     *  socket pipe
     */
    int _socket;
}
- (BOOL)sendToServer:(UIImage *)image;

@end
