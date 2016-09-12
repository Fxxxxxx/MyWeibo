//
//  BaseNavigationController.m
//  Project2
//
//  Created by mac on 16/8/3.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "BaseNavigationController.h"
#import "ThemeManager.h"
#import "ThemeImgView.h"
@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ThemeChange" object:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange) name:@"ThemeChange" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self themeChange];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) themeChange{
    [self.navigationBar setBackgroundImage:[[ThemeManager shareInstance] ThemeimageWithImageName:@"mask_titlebar64.png"]forBarMetrics:UIBarMetricsDefault];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
