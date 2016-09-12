//
//  DataService.h
//  Project2
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef void  (^successBlock)(id result);
typedef void (^failureBlock)(NSError * error);
@interface DataService : NSObject

+(void)requestWithUrl:(NSString *)url mathod:(NSString *)mathod params:(NSDictionary *)params data:(NSDictionary *)dataDic success:(successBlock)sblock failure:(failureBlock)fblock;


@end
