//
//  ThemeManager.h
//  Project2
//
//  Created by mac on 16/8/4.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ThemeManager : NSObject
@property (nonatomic,copy) NSString * ThemeName;
@property (nonatomic,strong) NSDictionary * ThemeDic;
+ (instancetype)shareInstance;
- (UIImage *) ThemeimageWithImageName:(NSString *)imgname;
- (UIColor *) ThemeColorWithColorName:(NSString *)colNmae;
- (NSString *)ThemePath:(NSString *)themeName;
@end
