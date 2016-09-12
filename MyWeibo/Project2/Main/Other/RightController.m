//
//  RightController.m
//  Project2
//
//  Created by mac on 16/8/8.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "RightController.h"
#import "ThemeButton.h"
#import "BaseNavigationController.h"
#import "SendViewController.h"

@interface RightController ()

@end

@implementation RightController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor grayColor];
    
    ThemeButton * button = [ThemeButton buttonWithType:UIButtonTypeCustom];
    button.imgName = @"newbar_icon_1.png";
    button.frame = CGRectMake(100 - 40 - 20, 60, 40, 40);
    [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}

- (void) clickAction:(ThemeButton *)button{
    SendViewController * sendCtr = [[SendViewController alloc] init];
    BaseNavigationController * nav = [[BaseNavigationController alloc] initWithRootViewController:sendCtr];
    
    [self presentViewController:nav animated:YES completion:nil];
}

@end
