//
//  WeiboTableView.m
//  Project2
//
//  Created by mac on 16/8/5.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "WeiboTableView.h"
#import "WeiboCell.h"
#import "WeiboModel.h"
#import "WeiboCell.h"
#import "Common.h"
@implementation WeiboTableView

-(void)awakeFromNib{
    self.delegate = self;
    self.dataSource = self;
    self.rowHeight = 60;
}

- (void)setWeiboList:(NSArray *)WeiboList{
    _WeiboList = WeiboList;
    [self reloadData];
}

#pragma mark---datasource
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    WeiboModel * model = _WeiboList[indexPath.row];
    return 70 + model.textHeight + model.imageHeight + model.reTextHeight + model.reImageHeight + 30;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;{
    return _WeiboList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath;{
    WeiboCell * cell = [[WeiboCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    WeiboModel * model = _WeiboList[indexPath.row];
    cell.weiboModel = model;
    return cell;
}

@end
