//
//  DataService.m
//  Project2
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "DataService.h"
#import "AppDelegate.h"
#import "AFNetworking.h"
@implementation DataService

+(void)requestWithUrl:(NSString *)url mathod:(NSString *)mathod params:(NSDictionary *)params data:(NSDictionary *)dataDic success:(successBlock)sblock failure:(failureBlock)fblock;{
    AppDelegate * delegate = [UIApplication sharedApplication].delegate;
    NSString * accessToken = delegate.sinaweibo.accessToken;
    //拼接url
    NSMutableString * urlStr = [NSMutableString stringWithString:@"https://api.weibo.com/2/"];
    [urlStr appendString:url];
    //设置参数
    NSMutableDictionary * paramsDic = [[NSMutableDictionary alloc] initWithDictionary:params];
    [paramsDic setObject:accessToken forKey:@"access_token"];
    
    
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager manager];
    
    
    if ([mathod caseInsensitiveCompare:@"POST"] == NSOrderedSame) {
        if(dataDic == nil){
            [manager POST:urlStr parameters:paramsDic success:^(NSURLSessionDataTask *task, id responseObject) {
                sblock(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                fblock(error);
            }];
        }else{
            [manager POST:urlStr parameters:paramsDic constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (NSString * key in dataDic) {
                    [formData appendPartWithFileData:[dataDic objectForKey:key] name:key fileName:key mimeType:@"image/jpeg"];
                }
            } success:^(NSURLSessionDataTask *task, id responseObject) {
                sblock(responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                fblock(error);
            }];
        }
        
    }else if ([mathod caseInsensitiveCompare:@"GET"] == NSOrderedSame){
        [manager GET:urlStr parameters:paramsDic success:^(NSURLSessionDataTask *task, id responseObject) {
            sblock(responseObject);
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            fblock(error); 
        }];
    }
    
}

@end
