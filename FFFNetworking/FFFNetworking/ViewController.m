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
     *  封装的AFN方法
     */
//    [tools requestAFNNetworkRequest];
    
    
}




@end
