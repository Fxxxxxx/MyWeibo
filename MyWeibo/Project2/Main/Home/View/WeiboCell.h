//
//  WeiboCell.h
//  Project2
//
//  Created by mac on 16/8/5.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXLabel.h"
@class WeiboModel;
@interface WeiboCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (strong, nonatomic) IBOutlet UIImageView *UserImg;
@property (strong, nonatomic) IBOutlet UILabel *NikeName;
@property (strong, nonatomic) IBOutlet UILabel *Time;
@property (strong, nonatomic) IBOutlet UILabel *Source;
@property (nonatomic,strong) WeiboModel * weiboModel;
@property (nonatomic,strong) WXLabel * WeiboText;
@property (nonatomic,strong) WXLabel * reWeiboText;
@property (nonatomic,strong) UICollectionView * imgsView;
@property (nonatomic,strong) UICollectionView * reImgsView;
@property (nonatomic,strong) UIImageView * retweetedView;
@end
