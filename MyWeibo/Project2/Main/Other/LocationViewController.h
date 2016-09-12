//
//  LocationViewController.h
//  Project2
//
//  Created by mac on 16/8/12.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^locationBlock)(NSString * address);
@interface LocationViewController : UITableViewController
@property (nonatomic,copy) locationBlock location;
@end
