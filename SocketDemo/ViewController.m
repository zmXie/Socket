//
//  ViewController.m
//  SocketDemo
//
//  Created by CHT-Technology on 2017/4/1.
//  Copyright © 2017年 CHT-Technology. All rights reserved.
//

#import "ViewController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#import <arpa/inet.h>
#import <objc/runtime.h>
#import <objc/message.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    /*
     1.创建socket
     int	socket(int, int, int);

     @param AF_INET ->协议组: UDP, TCP, etc.
     @param SOCK_STREAM SOCK_STREAM(TCP流)；SOCK_DGRAM（UDP数据报）；SOCK_RAW（原始套接字）  
     @param IPPROTO_TCP ->具体使用的传输协议
     @return int ->返回的是正数，代表 socket创建成功
     */

    int client = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
    
    /*
     2.连接
     int	connect(int, const struct sockaddr *, socklen_t) __DARWIN_ALIAS_C(connect);
     
     @param client ->客服端的socket.
     @param serviceAddr -> 连接参数的一个结构体
     @param sizeof(serviceAddr) -> 结构体指向的内存长度
     @return int ->返回的是错误码，为0则表示连接成功，否则失败
     */
    struct sockaddr_in serviceAddr;
    serviceAddr.sin_family = AF_INET;
    serviceAddr.sin_port = htons(1234); //端口  nc -lk(固定的命令行,开启端口)
    serviceAddr.sin_addr.s_addr = inet_addr("192.168.11.101"); //使用本机作为服务器地址来测试
    int code = connect(client, (const struct sockaddr *)&serviceAddr, sizeof(serviceAddr));
    if (code == 0) {
        NSLog(@"连接成功了!");
        
        /*
         3.发送消息
         ssize_t	send(int, const void *, size_t, int) __DARWIN_ALIAS_C(send);
         
         @param client ->客服端的socket.
         @param message.UTF8String -> 发送内容的地址
         @param size_t -> 消息长度
         @param int 发送标识，表示发送消息
         @return ssize_t -> 发送字符的长度
         */
        NSString *message = @"hello world";
        ssize_t sendL = send(client, message.UTF8String, message.length, 0);
        NSLog(@"发送了%zd个字符",sendL);
        
        /*
         4.接收消息
         ssize_t	recv(int, void *, size_t, int) __DARWIN_ALIAS_C(recv);
         
         @param client ->客服端的socket.
         @param message.UTF8String -> 消息内容的地址
         @param sizeof(serviceAddr) -> 消息长度
         @param int 发送标识，表示发送消息
         @return ssize_t -> 发送字符的长度
         
         */
        
        //消息内容缓存
        uint8_t buffer[1024];
        ssize_t recvL = recv(client, buffer, sizeof(buffer), 0);
        NSData *data = [NSData dataWithBytes:buffer length:recvL];
        NSLog(@"%zd === %@",recvL,[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]);
        
    }else{
        NSLog(@"危险期，禁止连接🚫,%d",code);
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
