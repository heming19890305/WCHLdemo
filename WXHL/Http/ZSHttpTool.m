//
//  ZSHttpTool.m
//  PlayVR
//
//  Created by 赵升 on 2016/10/14.
//  Copyright © 2016年 ZS. All rights reserved.
//

#import "ZSHttpTool.h"
#import "AFNetworking.h"

static NSString * kBaseUrl = SERVER_HOST;


@interface AFHttpClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end

@implementation AFHttpClient

+ (instancetype)sharedClient {
    
    static AFHttpClient * client = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        NSURLSessionConfiguration * configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        
        client = [[AFHttpClient alloc] initWithBaseURL:[NSURL URLWithString:kBaseUrl] sessionConfiguration:configuration];
        //接收参数类型
        client.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html", @"text/json", @"text/javascript",@"text/plain",@"image/gif", nil];
        //设置超时时间
        client.requestSerializer.timeoutInterval = 60;
        //安全策略
        client.securityPolicy = [AFSecurityPolicy defaultPolicy];
        
    });
    
    return client;
}

@end

@implementation ZSHttpTool

+ (void)getWithPath:(NSString *)path
             params:(NSDictionary *)params
            success:(HttpSuccessBlock)success
            failure:(HttpFailureBlock)failure {
    //获取完整的url路径
    NSString * url = [kBaseUrl stringByAppendingPathComponent:path];
//
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 10.f;
//
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"Cookie"];
//

    //[manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"] forHTTPHeaderField:@"JSESSIONID"];
    
    
//    NSArray *cookS = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:url]];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookS];
//    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Cookie"];
    
    [[AFHttpClient sharedClient] GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
//        NSDictionary *fields = ((NSHTTPURLResponse*)task.response).allHeaderFields;
//
//        NSURL *useurl = [NSURL URLWithString:kBaseUrl];
//        
        
        
        //NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:useurl];
    
        
        //获取cookie方法1
//        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:useurl];
//        for (NSHTTPCookie *cookie in cookies) {
//            [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:@"Cookie"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
        
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
    
}

+ (void)postWithPath:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure {
    //获取完整的url路径
    NSString * url = [kBaseUrl stringByAppendingPathComponent:path];
    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    [manager setRequestSerializer:[AFHTTPRequestSerializer serializer]];
//    [manager.requestSerializer willChangeValueForKey:@"timeoutInterval"];
//    manager.requestSerializer.timeoutInterval = 10.f;
//
//    [manager.requestSerializer didChangeValueForKey:@"timeoutInterval"];
//    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Cookies"] forHTTPHeaderField:@"Cookie"];
//
//
//    [manager.requestSerializer setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"Cookie"] forHTTPHeaderField:@"JSESSIONID"];
//
//
//    NSArray *cookS = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL:[NSURL URLWithString:url]];
//    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:cookS];
//    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Cookie"];
//
    
    [[AFHttpClient sharedClient] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功
        

//        NSDictionary *fields = ((NSHTTPURLResponse*)task.response).allHeaderFields;
//
//        NSURL *url = [NSURL URLWithString:@"http://dev.skyfox.org/cookie.php"];

//        //获取cookie方法1
//        NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:fields forURL:url];
//        for (NSHTTPCookie *cookie in cookies) {
//
//            [[NSUserDefaults standardUserDefaults] setObject:cookie.value forKey:@"Cookie"];
//            [[NSUserDefaults standardUserDefaults] synchronize];
//        }
        
        success(responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (error.code == -1001) {
            [SVProgressHUD showInfoWithStatus:@"请求超时"];
            
        }
        
        failure(error);
        
    }];
    
}

+ (void)downloadWithPath:(NSString *)path
                 success:(HttpSuccessBlock)success
                 failure:(HttpFailureBlock)failure
                progress:(HttpDownloadProgressBlock)progress {
    
    //获取完整的url路径
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:path];
    
    //下载
    NSURL *URL = [NSURL URLWithString:urlString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDownloadTask *downloadTask = [[AFHttpClient sharedClient] downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        
        progress(downloadProgress.fractionCompleted);
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        //获取沙盒cache路径
        NSURL * documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSCachesDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        
        if (error) {
            failure(error);
        } else {
            success(filePath.path);
        }
        
    }];
    
    [downloadTask resume];
    
}

+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                  thumbName:(NSString *)imagekey
                      image:(UIImage *)image
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress {
    
    //获取完整的url路径
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:path];
    
//    NSData * data = UIImagePNGRepresentation(image);
    NSData * data  = UIImageJPEGRepresentation(image, 0.1);
    
    [[AFHttpClient sharedClient] POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:data name:imagekey fileName:@"01.png" mimeType:@"image/png/jpeg/jpg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}



+ (void)uploadImageWithPath:(NSString *)path
                     params:(NSDictionary *)params
                 thumbNames:(NSArray *)imagekeys
                     images:(NSArray *)images
                    success:(HttpSuccessBlock)success
                    failure:(HttpFailureBlock)failure
                   progress:(HttpUploadProgressBlock)progress {
    
    //获取完整的url路径
    NSString * urlString = [kBaseUrl stringByAppendingPathComponent:path];
    
    [[AFHttpClient sharedClient] POST:urlString parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        for (int i = 0; i < images.count; i++) {
            UIImage * image = images[i];
            NSString * imagekey = imagekeys[i];
//            NSData * data = UIImagePNGRepresentation(image);
            NSData * data  = UIImageJPEGRepresentation(image, 0.1);

            [formData appendPartWithFileData:data name:imagekey fileName:[NSString stringWithFormat:@"%2d.png",i] mimeType:@"image/png/jpg/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
        progress(uploadProgress.fractionCompleted);
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
}




+ (void)postWithPathh:(NSString *)path
              params:(NSDictionary *)params
             success:(HttpSuccessBlock)success
             failure:(HttpFailureBlock)failure {
    //获取完整的url路径
    NSString * url = [kBaseUrl stringByAppendingPathComponent:path];
    
    [[AFHttpClient sharedClient] POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        failure(error);
        
    }];
    
}




@end
