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

/**
 1. AFN的使用步骤
 ============================================================
 1> 实例化AFHTTPSessionManager
 AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
 
 2> 设置请求的数据类型
 (1) AFHTTPRequestSerializer    二进制或者字符串的数据类型，也就是在浏览器中可以使用的格式
 *** 默认的请求类型
 (2) AFJSONRequestSerializer    向服务器发送JSON格式的数据
 (3) AFPropertyListRequestSerializer    想服务器发送Plist格式的数据
 
 3> 设置响应(服务器返回)的数据类型
 (1) AFHTTPResponseSerializer   返回二进制或者字符串的类型
 使用以下代码可以查看返回结果
 NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
 
 (2) AFJSONResponseSerializer   返回JSON格式的数据类型，会自动反序列化(NSDictionary & NSArray)
 *** 默认的返回类型
 
 (3) AFXMLParserResponseSerializer 返回XML的解析器，需要自行根据返回的数据进行解析
 (4) AFXMLDocumentResponseSerializer (Mac OS X)
 (5) AFPropertyListResponseSerializer 返回的是PList格式的数据
 NSString *result = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
 
 (6) AFImageResponseSerializer      返回图像，从网络上返回图像，通常使用SDWebImage框架
 (7) AFCompoundResponseSerializer   组合形式
 */

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

#pragma mark - 工具方法

//返回网络状态
-(NSString *)monitorNetworkStatus{
    
    __block NSMutableString *netStatus = [[NSMutableString alloc] initWithFormat:@"未知"];
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager manager];
    [manager startMonitoring];
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case -1:
                [netStatus setString:@"未知"];
                break;
            case 1:
                [netStatus setString:@"3G"];
                break;
            case 0:
                [netStatus setString:@"无连接"];
                break;
            case 2:
                [netStatus setString:@"WIFI"];
                break;
            default:
                [netStatus setString:@"无法识别"];
                break;
        }
    }];
    return netStatus;
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

///封装的AFN的网络方法 默认返回的是json数据
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

///封装的AFN的网络方法  返回的是XML数据类型和plist数据
-(void)AFNRequestMethod:(NSString *)requestMethod URLString:(NSString *)urlString parameters:(id)parameters success:(void (^)(id))successObject failure:(void(^)(NSError *))failure dataType:(NSString *)XMLWithPlist{
    
    AFHTTPSessionManager *session = [AFHTTPSessionManager manager];
    
    if ([XMLWithPlist isEqual:@"XML"]) {
        session.responseSerializer = [AFXMLParserResponseSerializer serializer];
    }else if([XMLWithPlist isEqual:@"PLIST"]){
        
        session.responseSerializer = [AFPropertyListResponseSerializer serializer];
        // plist默认只支持 application/x-plist mimetype
        // 如果要支持text/plain，需要设置响应者的可接受ContentTypes
        session.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain"];
    }
    
    if ([requestMethod isEqual:@"GET"] ) {
        [session GET:urlString parameters:parameters progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            successObject(responseObject);

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
 *  POST上传
 */
-(void)postUploadWithURLString:(NSString *)urlString success:(void(^)(id data))success failure:(void(^)(NSError *error))failure{
    
    AFHTTPSessionManager *manger = [AFHTTPSessionManager manager];
    
    [manger POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // formData 是一个遵守了AFMultipartFormData协议的对象
        // 参数：
        // 1. FileURL对应本地的文件URL
        // 2. name 上传的参数名称，对应的是php文件中指定的字段名
        // 3. fileName 上传的文件名
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"head1.png" withExtension:nil];
        // appendPartWithFileURL完成拼接POST字符串的工作
        //        [formData appendPartWithFileURL:fileURL name:@"uploadFile" error:NULL];
        [formData appendPartWithFileURL:fileURL name:@"uploadFile" fileName:@"123" mimeType:@"image/png" error:NULL];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure(error);
    }];
}

/**
 *  下载操作
 */
-(void)downloadWithURLString:(NSString *)urlString{
    
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    AFURLSessionManager *manger = [[AFURLSessionManager alloc] initWithSessionConfiguration:config];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSessionDownloadTask *downTask = [manger downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) { //下载进度
        
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
         // response.suggestedFilename就是从服务器上要下载的文件名
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        NSString *filePath = [cachePath stringByAppendingPathComponent:response.suggestedFilename];
        NSURL *url = [NSURL fileURLWithPath:filePath];
        // 返回的URL就是要将下载文件保存到的路径
        return url;
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        
    }];
    [downTask resume];
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

#pragma mark - NetworkTools_封装AFN_实现文件的上传和下载





#pragma mark - NetworkTools__实现文件的上传

#define kBoundary @"kBoundary"

/**
 *  异步实现单文件上传
 */

-(void)uploadFileWithUrlString:(NSString *)urlString filePath:(NSString *)filePath fileKey:(NSString *)fileKey fileName:(NSString *)fileName{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    
    request.HTTPBody = [self getFilePath:filePath fileKey:fileKey fileName:fileName];
    
    //告诉服务器上传的不是普通文本， 是一个文件信息
    NSString *type = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",kBoundary];
    [request setValue:type forHTTPHeaderField:@"Content-Type"];

    [[[NSURLSession alloc] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        NSLog(@"response:%@",response);
        
        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    }] resume];
}


-(NSData *)getFilePath:(NSString *)filePath fileKey:(NSString *)fileKey fileName:(NSString *)fileName{
    
    NSMutableData *data = [NSMutableData data];
    //1.设置上传文件的上边界   \r\n 就是换行，能够适配所有服务器
    NSMutableString *headerStrM = [NSMutableString stringWithFormat:@"--%@\r\n",kBoundary];
    
    // Content-Disposition: form-data :告诉服务器,这是一个文件参数(非文本参数)
    // userfile :服务器接收文件参数的 key 值,一般是后台开发人员告诉我们
    // filename :上传文件保存在服务器中的文件名.
    [headerStrM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",fileKey,fileName];
    
    //上传文件的文件类型
    NSString *fileType = [self getFileTypeWithFilePath:filePath];
    [headerStrM appendFormat:@"Content-Type: %@\r\n\r\n",fileType];
    
    //将上边界转换成二进制数据
    NSData *headerData = [headerStrM dataUsingEncoding:NSUTF8StringEncoding];
    [data appendData:headerData];
    
    //2.上传文件内容
    //2.1 获得文件路径
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [data appendData:fileData];
    
    //3.设置上传文件的下边界
    NSMutableString *footerStrM = [NSMutableString stringWithFormat:@"\r\n--%@--\r\n",kBoundary];
    //将下边界转换成二进制数据
    NSData *footerData = [footerStrM dataUsingEncoding:NSUTF8StringEncoding];
    [data appendData:footerData];
    return data;
}

/**
 *  动态的获取文件类型  -> 这是同步的方法，安全
 *  @param filePath 文件路径
 *  @return 返回的是文件类型
 */
-(NSString *)getFileTypeWithFilePath:(NSString *)filePath{
    
    //发送一个本地请求。来获得文件类型
    NSString *urlString = [NSString stringWithFormat:@"file://%@",filePath];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    __block NSString *type = nil;
    //发送一个同步请求，response中存储着服务器的相应
    [[[NSURLSession alloc] dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        type = response.MIMEType;
    }] resume];
    return type;
}


/**
 *  异步实现多文件上传的方法
 */
-(void)uploadFilesWithUrlString:(NSString *)urlString FileDict:(NSDictionary *)fileDict fileKey:(NSString *)fileKey paramater:(NSDictionary *)paramater{
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
//    request.HTTPBody = [self getFilePath:fil fileKey:<#(NSString *)#> fileName:<#(NSString *)#>]
    
}


-(void)getDataWithFileDict:(NSDictionary *)fileDict  fileKey:(NSString *)fileKey paramater:(NSDictionary *)paramater{
    
    NetworkTools *mgr = [NetworkTools shareNetworkTool];
    
    NSMutableData *data = [NSMutableData data];
    //设置需要上传文件的格式
    //遍历文件参数字典，得到的就是格式化之后的文件参数
    
    [fileDict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        
        NSString *fileName = key;
        NSString *filePath = obj;
        
        //文件的上边界
        NSMutableString *headerStrM = [NSMutableString stringWithFormat:@"\r\n--%@\r\n",kBoundary];
        [headerStrM appendFormat:@"Content-Disposition: form-data; name=%@; filename=%@\r\n",fileKey,fileName];
        
        //动态获取文件类型
        
//        NSString *type = [mgr get]
        
    }];

}



-(void)withFileDict:(NSDictionary *)fileDict fileKey:(NSString *)fileKey fileName:(NSString *)fileName{
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
