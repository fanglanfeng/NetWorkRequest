//
//  NetworkTools.h
//  0网络数据请求封装
//
//  Created by admin on 15/7/7.
//  Copyright © 2015年 admin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

#warning  测试接口 --> 真实存在的地址,只能用作数据获取，不得作为其他用途
static NSString *urlString = @"http://mobile.gocent.net/m/homePageExt/listFloorExtNew";

@interface NetworkTools : NSObject


#pragma mark - NetworkTools的最主要方法，可以直接使用,Main

///单例对象
+(instancetype)shareNetworkTool;

/**
 *  封装的AFN的网络请求，主要是做网络剥离，防止后期网络方法的变更
 *
 *  @param requestMethod 请求方式 GET&POST
 *  @param urlString     请求的URL
 *  @param parameters    传递进去的数据,可以为nil
 *  @param successObject 成功之后返回的数据
 *  @param failure       失败返回的错误
 */
-(void)AFNRequestMethod:(NSString *)requestMethod URLString:(NSString *)urlString parameters:(id)parameters success:(void (^)(id data))successObject failure:(void(^)(NSError * error))failure;

/**
 *  源生方法的网络请求
 *
 *  @param method        请求方式 GET&POST
 *  @param urlString     请求的URL
 *  @param data          传递进去的数据,可以为nil,这里指的是二进制数据
 *  @param successObject 成功之后返回的数据
 *  @param failure       失败返回的错误
 */
-(void)sourceRequestMethod:(NSString *)method URLString:(NSString *)urlString parameters:(NSData *)parameters success:(void (^)(id data))successObject failure:(void (^)(NSError *error))failure;

#pragma mark - NetworkTools下面是直接封装好的网络请求方法，可以将请求的内容都放在这个方法里面，也可以做测试用

/**
 *  封装AFN的网络请求，也可以留作测试用
 */
-(void)requestAFNNetworkRequest;

/**
 *  封装源生的网络请求，也可以留作测试用
 */
-(void)requesSourceNetRequest;


#pragma mark - NetworkTools下面主要是做扩展和测试用的 - 对Block不熟悉慎用

/**
 *  定义的block,可用作扩展，做数据的返回，或者处理作用
 */
@property(nonatomic,copy) void(^backData)(id urlData);



/**
 *  专做测试的用途
 *
 *  @param data 需要测试的返回的数据
 */
-(void)text:(void (^)(NSString *data))data;

@end
