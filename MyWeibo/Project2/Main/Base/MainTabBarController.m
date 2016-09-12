//
//  MainTabBarController.m
//  Project2
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "MainTabBarController.h"
#import "Common.h"
#import "ThemeManager.h"
#import "ThemeButton.h"
#import "ThemeImgView.h"
@interface MainTabBarController (){
    ThemeManager * manager;
    ThemeImgView * _selectImgView;
}

@end

@implementation MainTabBarController



- (void)viewDidLoad {
    [super viewDidLoad];
    manager = [ThemeManager shareInstance];
    [self _creatController];
    [self _romoveSubViews];
    [self _creatTabbar];
    
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ThemeChange" object:nil];
}

- (void) _creatController{
    NSArray * names = @[@"Home",@"Message",@"Profile",@"Discover",@"More"];
    NSMutableArray * subCtrs = [NSMutableArray array];
    for (NSString * name in names) {
        UIStoryboard * sb = [UIStoryboard storyboardWithName:name bundle:nil];
        [subCtrs addObject:[sb instantiateInitialViewController]];
    }
    self.viewControllers = subCtrs;
}

- (void) _romoveSubViews{
    Class tabbarButton = NSClassFromString(@"UITabBarButton");
    for (UIView * view in self.tabBar.subviews) {
        if ([view isKindOfClass:tabbarButton]) {
            [view removeFromSuperview];
        }
    }
}

- (void) _creatTabbar{
    ThemeImgView * BarView = [[ThemeImgView alloc] initWithFrame:self.tabBar.bounds];
    BarView.imgName = @"mask_navbar.png";
    [self.tabBar addSubview:BarView];
    CGFloat width = kScreenWidth / 5;
    _selectImgView = [[ThemeImgView alloc] init];
    _selectImgView.imgName = @"home_bottom_tab_arrow.png";
    _selectImgView.frame = CGRectMake(0, 0, width, TabBarHeight);
    for (NSInteger i = 0; i < 5; i++) {
        NSString * imgName = [NSString stringWithFormat:@"home_tab_icon_%ld@2x.png",i+1];
        ThemeButton * button = [ThemeButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(width * i, 0, width, TabBarHeight);
        button.imgName = imgName;
        button.tag = i;
        [self.tabBar addSubview:button];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        
        if (i == 0) {
            _selectImgView.center = button.center;
        }
    }
    [self.tabBar addSubview:_selectImgView];
    
    
}

- (void) buttonAction:(UIButton *)sender{
    self.selectedIndex = sender.tag;
    [UIView animateWithDuration:0.35 animations:^{
        _selectImgView.center = sender.center;
    }];
}



@end
