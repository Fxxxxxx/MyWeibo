//
//  AppDelegate.m
//  Project2
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "AppDelegate.h"
#import "MMDrawerController.h"
#import "MainTabBarController.h"
#import "RightController.h"
#import "LeftController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    MainTabBarController * mainTabBar = [[MainTabBarController alloc] init];
    RightController * rightDrawerViewController = [[RightController alloc] init];
    LeftController * leftDrawerViewController = [[LeftController alloc] init];
    MMDrawerController * MMDCtr = [[MMDrawerController alloc]initWithCenterViewController:mainTabBar leftDrawerViewController:leftDrawerViewController rightDrawerViewController:rightDrawerViewController];
    MMDCtr.openDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    MMDCtr.closeDrawerGestureModeMask = MMOpenDrawerGestureModeAll;
    MMDCtr.maximumRightDrawerWidth = 150;
    MMDCtr.maximumLeftDrawerWidth = 200;
    
    
    self.window.rootViewController = MMDCtr;
    
        _sinaweibo = [[SinaWeibo alloc] initWithAppKey:kAppKey
                                        appSecret:kAppSecret
                                   appRedirectURI:kAppRedirectURI
                                      andDelegate:nil];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSDictionary *sinaweiboInfo = [defaults objectForKey:@"SinaWeiboAuthData"];
        if ([sinaweiboInfo objectForKey:@"AccessTokenKey"] &&
            [sinaweiboInfo objectForKey:@"ExpirationDateKey"] &&
            [sinaweiboInfo objectForKey:@"UserIDKey"]) {
            _sinaweibo.accessToken = [sinaweiboInfo objectForKey:@"AccessTokenKey"];
            _sinaweibo.expirationDate = [sinaweiboInfo objectForKey:@"ExpirationDateKey"];
            _sinaweibo.userID = [sinaweiboInfo objectForKey:@"UserIDKey"];
        }
        return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
