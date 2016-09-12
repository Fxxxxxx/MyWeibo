//
//  AppDelegate.h
//  Project2
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinaWeibo.h"
#define kAppKey             @"1279890117"
#define kAppSecret          @"a8f30c5ccca63842d61d3aa9543105b9"
#define kAppRedirectURI     @"http://www.baidu.com"


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) SinaWeibo * sinaweibo;

@end

