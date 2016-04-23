//
//  ViewController.m
//  FFFNetworking
//
//  Created by admin on 15/7/7.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "ViewController.h"
#import "NetworkTools.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NetworkTools *tools = [NetworkTools shareNetworkTool];
    
    /**
     *  封装的源生方法
     */
    [tools requesSourceNetRequest];
        
    /**
     *  封装的源生网络请求
     *
     *  @param data 需要传递进去的数据，可以为nil
     *
     *  @return 返回数据
     */
    [tools sourceRequestMethod:@"GET" URLString:urlString parameters:nil success:^(id data) {
        NSLog(@"%@",data);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
    /**
     *  封装的AFN方法
     */
    [tools requestAFNNetworkRequest];
    
    
    /**
     *  封装的AFN的网络请求
     *
     *  @param data 需要传递进去的数据，可以为nil
     *
     *  @return 返回数据
     */
    [tools AFNRequestMethod:@"GET" URLString:urlString parameters:nil success:^(id data) {
        NSLog(@"%@",data);
    } failure:^(NSError *error) {
        NSLog(@"%@",error);
    }];
    
}




@end
