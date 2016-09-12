//
//  MoreViewController.m
//  Project2
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "MoreViewController.h"
#import "ThemeImgView.h"
#import "ThemeLabel.h"
#import "ThemeManager.h"
#import "SinaWeibo.h"
#import "AppDelegate.h"
@interface MoreViewController ()<UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *MoreTableView;
@property (weak, nonatomic) IBOutlet ThemeImgView *C1ImgView;
@property (weak, nonatomic) IBOutlet ThemeLabel *C1label1;
@property (weak, nonatomic) IBOutlet ThemeLabel *C1label2;
@property (weak, nonatomic) IBOutlet ThemeImgView *C2imgView;
@property (weak, nonatomic) IBOutlet ThemeLabel *C2label1;

@property (weak, nonatomic) IBOutlet ThemeLabel *C3label;
@property (weak, nonatomic) IBOutlet ThemeLabel *C4label;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _C1ImgView.imgName = @"more_icon_theme.png";
    _C1label1.ColorName = @"More_Item_Text_color";
    _C1label2.ColorName = @"More_Item_Text_color";
    _C2label1.ColorName = @"More_Item_Text_color";
    _C3label.ColorName = @"More_Item_Text_color";
    _C4label.ColorName = @"More_Item_Text_color";
    _MoreTableView.delegate = self;
    [self themeChange];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        //监听主题切换的通知
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(themeChange) name:@"ThemeChange" object:nil];
    }
    return self;
}

- (void)themeChange{
    //表示图的背景颜色和分割线的颜色
    
    UIColor *tableViewColor = [[ThemeManager shareInstance]ThemeColorWithColorName:@"More_Item_color"];
    
    self.tableView.backgroundColor = tableViewColor;
    
    //线的颜色
    UIColor *lineColor = [[ThemeManager shareInstance]ThemeColorWithColorName:@"More_Item_Line_color"];
    
    _C1label2.text = [ThemeManager shareInstance].ThemeName;
    
    self.tableView.separatorColor = lineColor;
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tabBarController.tabBar setHidden:NO];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    if ([indexPath isEqual:[NSIndexPath indexPathForRow:1 inSection:0]]) {
//        SinaWeibo * sinaweibo = [self sinaweibo];
//        [sinaweibo logOut];
//        [sinaweibo logIn];
//    }
}
- (SinaWeibo *)sinaweibo
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return delegate.sinaweibo;
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
- (void)removeAuthData
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"SinaWeiboAuthData"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
#pragma mark - SinaWeibo Delegate

- (void)sinaweiboDidLogIn:(SinaWeibo *)sinaweibo
{
    
    [self storeAuthData];
    //登录成功就请求数据
    [UIView animateWithDuration:.3 animations:^{
        self.tabBarController.selectedIndex = 0;
    }];
    
    
}
- (void)sinaweiboDidLogOut:(SinaWeibo *)sinaweibo
{
    NSLog(@"sinaweiboDidLogOut");
    [self removeAuthData];
}
@end
