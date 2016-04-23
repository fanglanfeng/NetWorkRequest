//
//  NetworkTools.m
//  0网络数据请求封装
//
//  Created by admin on 15/7/7.
//  Copyright © 2015年 admin. All rights reserved.
//

#import "NetworkTools.h"
#import "AFNetworking.h"
#import "AFHTTPSessionManager.h"

@interface NetworkTools ()

@end

@implementation NetworkTools

///单例对象
+(instancetype)shareNetworkTool{
    static NetworkTools *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super alloc] init];
    });
    return instance;
}

/**
 *  AFN的网络请求,扩展和测试用，可以将所有请求都放在此方法里面
 */
-(void)requestAFNNetworkRequest{
    ///网络请求的方式
    NSString *method = @"GET";
    //网络请求的urlString；
    NSString *urlString = @"http://mobile.gocent.net/m/homePageExt/listFloorExtNew";
    //网络请求中的数据--》一般是用作POST请求
    [self AFNRequestMethod:method URLString:urlString parameters:nil success:^(id data) {
         NSLog(@"%s,%@",__func__,data);
    } failure:^(NSError *error) {
         NSLog(@"%s,%@",__func__,error);
    }];
}

///封装的AFN的网络方法
-(void)AFNRequestMethod:(NSString *)requestMethod URLString:(NSString *)urlString parameters:(id)parameters success:(void (^)(id))successObject failure:(void(^)(NSError *))failure {
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    if ([requestMethod isEqual:@"GET"] ) {
        [session GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successObject(responseObject);
#warning mark - 这里是用单独创建block回调值得方法，-->> 下面不在重写,自己可以放在相应的的位置
//            [self blockBackData:responseObject];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }else if([requestMethod isEqual:@"POST"]){
        [session POST:urlString parameters:parameters progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successObject(responseObject);
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure(error);
        }];
    }
}

/**
 *  源生的网络请求，扩展和测试用，可以将所有请求都放在此方法里面
 */
-(void)requesSourceNetRequest{
    
    NSString *urlString = @"http://mobile.gocent.net/m/homePageExt/listFloorExtNew";
    NSString *method = @"GET";
    //测试数据
//    NSString *passData = [NSString stringWithFormat:@"%@",@"ds"]; 
//    NSData *data = [passData dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    
    [self sourceRequestMethod:method URLString:urlString parameters:nil success:^(id data) {
        NSLog(@"%s,%@",__func__,data);
    } failure:^(NSError * failure) {
         NSLog(@"%s,%@",__func__,failure);
    }];
}

///封装源生中的网络请求数据
-(void)sourceRequestMethod:(NSString *)method URLString:(NSString *)urlString parameters:(NSData *)parameters success:(void (^)(id))successObject failure:(void (^)(NSError *))failure{
    /**
     *  请求对象
     */
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.timeoutInterval = 60;
    //请求头有时候需要进行设置
    //    [request addValue:@"application/json;charset=utf-8" forHTTPHeaderField:@"Content-Type"];
    //    [request setValue:@"text/html,application/xhtml+xml,application/xml" forHTTPHeaderField:@"Accept"];
    if(parameters){
        request.HTTPBody = parameters;
    }
    request.HTTPMethod = method;
    /**
     *  创建请求任务
     */
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (data) {
            //NSLog(@"%s,data=%@",__func__,[NSJSONSerialization JSONObjectWithData:data options:0 error:NULL]);
            id returnData = [NSJSONSerialization JSONObjectWithData:data options:0 error:NULL];
            successObject(returnData);
        }else{
            failure(error);
        }
    }];
    [task resume];
}

/**
 *  后期可以做扩展用，可以不用
 *  @param data 网络请求到的数据
 */
-(void)blockBackData:(id)data{
    if (self.backData) {
        //NSLog(@"%s,%@",__func__,data);
        self.backData(data);
    }
}
//测试block,可以不用
-(void)text:(void (^)(NSString *data))data{
    //data(@"110");
}

@end
