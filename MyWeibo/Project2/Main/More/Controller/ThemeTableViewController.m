//
//  ThemeTableViewController.m
//  Project2
//
//  Created by Fxxx on 16/8/4.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "ThemeTableViewController.h"
#import "ThemeManager.h"
@interface ThemeTableViewController ()
@end

@implementation ThemeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tabBarController.tabBar.hidden = YES;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [ThemeManager shareInstance].ThemeDic.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //表视图的背景颜色和分割线的颜色
    
    UIColor *tableViewColor = [[ThemeManager shareInstance]ThemeColorWithColorName:@"More_Item_color"];
    
    self.tableView.backgroundColor = tableViewColor;
    
    //线的颜色
    UIColor *lineColor = [[ThemeManager shareInstance]ThemeColorWithColorName:@"More_Item_Line_color"];
    
    
    self.tableView.separatorColor = lineColor;
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ThemeCell" forIndexPath:indexPath];
    cell.textLabel.text = [ThemeManager shareInstance].ThemeDic.allKeys[indexPath.row];
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [[ThemeManager shareInstance] ThemeColorWithColorName:@"More_Item_Text_color"];
    if([cell.textLabel.text isEqualToString:[ThemeManager shareInstance].ThemeName]){
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    }else{
        cell.accessoryType = UITableViewCellAccessoryNone;
        
    }
    NSString * imgPath = [[[ThemeManager shareInstance] ThemePath:cell.textLabel.text] stringByAppendingPathComponent:@"more_icon_theme.png"];
    cell.imageView.image = [UIImage imageWithContentsOfFile:imgPath];
    // Configure the cell...
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [ThemeManager shareInstance].ThemeName = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    
    [tableView reloadData];
}



@end
