//
//  HomeViewController.m
//  Project2
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "HomeViewController.h"
#import "AppDelegate.h"
#import "SinaWeibo.h"
#import "SinaWeiboRequest.h"
#import "ThemeManager.h"
#import "YYModel.h"
#import "WeiboModel.h"
#import "WeiboTableView.h"
#import "WXRefresh.h"
#import "ThemeImgView.h"
#import "ThemeLabel.h"
#import "Common.h"
#import "MBProgressHUD.h"
#import <AudioToolbox/AudioToolbox.h>
@interface HomeViewController ()<SinaWeiboDelegate, SinaWeiboRequestDelegate>

@property (nonatomic,strong) NSMutableArray * WeiboList;
@property (weak, nonatomic) IBOutlet WeiboTableView *WeiboTable;
@property (nonatomic,strong) ThemeImgView * refreshView;
@end

@implementation HomeViewController{
    MBProgressHUD * hud;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    SinaWeibo * sinaweibo = [self sinaweibo];
    sinaweibo.delegate = self;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self.WeiboTable addPullDownRefreshBlock:^{
        WeiboModel * firstModel = [_WeiboList firstObject];
        NSString * firstID = firstModel.idstr;
        SinaWeiboRequest * request = [[self sinaweibo] requestWithURL:@"statuses/home_timeline.json" params:[@{@"since_id":firstID} mutableCopy] httpMethod:@"GET" delegate:self];
        request.tag = 1;
    }];
    [self.WeiboTable addInfiniteScrollingWithActionHandler:^{
        WeiboModel * lastModel = [self.WeiboList lastObject];
        NSString * lastID = [NSString stringWithFormat:@"%ld",[lastModel.idstr integerValue] - 1];
        SinaWeiboRequest * request = [[self sinaweibo] requestWithURL:@"statuses/home_timeline.json" params:[@{@"max_id":lastID} mutableCopy] httpMethod:@"GET" delegate:self];
        request.tag = 2;
    }];
    
    
    self.refreshView = [[ThemeImgView alloc] initWithFrame:CGRectMake(40, -40, kScreenWidth-80, 40)];
    self.refreshView.imgName = @"timeline_notify.png";
    [self.view addSubview:_refreshView];
    ThemeLabel * label = [[ThemeLabel alloc] initWithFrame:self.refreshView.bounds];
    label.ColorName = @"Mask_Notice_color";
    label.backgroundColor = [UIColor clearColor];
    label.tag = 2016;
    label.textAlignment = NSTextAlignmentCenter;
    [self.refreshView addSubview:label];

    [sinaweibo logIn];
    
    
}

- (NSMutableArray *)WeiboList{
    if (_WeiboList == nil) {
        _WeiboList = [NSMutableArray array];
    }
    return _WeiboList;
}

- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
}

- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)storeAuthData
{
    SinaWeibo *sinaweibo = [self sinaweibo];
    
    NSDictionary *authData = [NSDictionary dictionaryWithObjectsAndKeys:
                              sinaweibo.accessToken, @"AccessTokenKey",
                              sinaweibo.expirationDate, @"ExpirationDateKey",
                              sinaweibo.userID, @"UserIDKey",
                              sinaweibo.refreshToken, @"refresh_token", nil];
    [[NSUserDefaults standardUserDefaults] setObject:authData forKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    
    [self storeAuthData];
    //登录成功就请求数据
    SinaWeiboRequest * requset = [[self sinaweibo] requestWithURL:@"statuses/home_timeline.json" params:nil httpMethod:@"GET" delegate:self];
    requset.tag = 0;
    
    //设置遮挡视图
    hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.dimBackground = YES;
    hud.labelText = @"loading...";
}

- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
}

- (void)sinaweiboLogInDidCancel:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboLogInDidCancel");
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo logInDidFailWithError:(NSError *)error
{
    NSLog(@"sinaweibo logInDidFailWithError %@", error);
}

- (void)sinaweibo:(SinaWeibo *)sinaweibo accessTokenInvalidOrExpired:(NSError *)error
{
    NSLog(@"sinaweiboAccessTokenInvalidOrExpired %@", error);
    [self removeAuthData];
}

#pragma mark - SinaWeiboRequest Delegate

- (void)request:(SinaWeiboRequest *)request didFailWithError:(NSError *)error
{
    
}
//请求成功调用的方法
- (void)request:(SinaWeiboRequest *)request didFinishLoadingWithResult:(id)result
{
    NSMutableArray * tempArr = [NSMutableArray array];
    NSArray * statuses= result[@"statuses"];
    for (NSDictionary * status in statuses) {
        WeiboModel * weiboModel = [WeiboModel yy_modelWithDictionary:status];
        [tempArr addObject:weiboModel];
    }
    
    if (request.tag == 0) {
        self.WeiboList = tempArr;
        [_WeiboTable.pullToRefreshView stopAnimating];
        [hud hide:YES];
    }else if (request.tag == 1){
        NSIndexSet * set = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(0, tempArr.count)];
        [self showNewCount:tempArr.count];
        [self.WeiboList insertObjects:tempArr atIndexes:set];
        [_WeiboTable.pullToRefreshView stopAnimating];
    }else if (request.tag == 2){
        [self.WeiboList addObjectsFromArray:tempArr];
        [_WeiboTable.infiniteScrollingView stopAnimating];
    }
    
    _WeiboTable.WeiboList = [self WeiboList];
    [_WeiboTable reloadData];
}

- (void)showNewCount:(NSInteger)count{
    if (count <= 0) {
        return;
    }
    UILabel * label = [_refreshView viewWithTag:2016];
    label.text = [NSString stringWithFormat:@"%ld条新微博",count];
    [UIView animateWithDuration:3 animations:^{
        _refreshView.transform = CGAffineTransformMakeTranslation(0, 50);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.3 animations:^{
            _refreshView.transform = CGAffineTransformIdentity;
        }];
    }];
    
    //播放系统声音
    NSString * filePath = [[NSBundle mainBundle] pathForResource:@"msgcome" ofType:@"wav"];
    static UInt32 SoundId = 0;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)([NSURL fileURLWithPath:filePath]), &SoundId);
    AudioServicesPlayAlertSound(SoundId);
    
    
}

@end
