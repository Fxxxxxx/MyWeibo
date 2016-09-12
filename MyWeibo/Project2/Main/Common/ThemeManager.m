//
//  ThemeManager.m
//  Project2
//
//  Created by mac on 16/8/4.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "ThemeManager.h"

@implementation ThemeManager


+ (instancetype)shareInstance;{
    static ThemeManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ThemeManager alloc] init];
    });
    return instance;
}

- (instancetype)init{
    self = [super init];
    if (self) {
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"ThemeName"]) {
            _ThemeName = [[NSUserDefaults standardUserDefaults] valueForKey:@"ThemeName"];
        }
        else{
            _ThemeName = @"猫爷";
        }
    }
    return self;
}

- (void)setThemeName:(NSString *)ThemeName{
    _ThemeName = ThemeName;
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ThemeChange" object:nil];
    [[NSUserDefaults standardUserDefaults]setValue:_ThemeName forKey:@"ThemeName"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (NSString *)ThemePath:(NSString *)themeName{
    _ThemeDic = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Theme.plist" ofType:nil]];
    NSMutableString * Path = [NSMutableString string];
    [Path appendString:[[NSBundle mainBundle].resourcePath stringByAppendingPathComponent:@"Skins"]];
    [Path appendString:@"/"];
    [Path appendString:[_ThemeDic objectForKey:themeName]];
    return Path;
}

- (UIImage *) ThemeimageWithImageName:(NSString *)imgname;{
    NSString * imgPath = [self ThemePath:_ThemeName];
    imgPath = [imgPath stringByAppendingPathComponent:imgname];
    return [UIImage imageWithContentsOfFile:imgPath];
}


- (UIColor *) ThemeColorWithColorName:(NSString *)colNmae;{
    NSString * colorPath = [self ThemePath:_ThemeName];
    colorPath = [colorPath stringByAppendingPathComponent:@"config.plist"];
    NSDictionary * rgbDic = [NSDictionary dictionaryWithContentsOfFile:colorPath];
    rgbDic = rgbDic[colNmae];
    float r = [rgbDic[@"R"] floatValue];
    float g = [rgbDic[@"G"] floatValue];
    float b = [rgbDic[@"B"] floatValue];
    float alpha = rgbDic[@"alpha"] ? [rgbDic[@"alpha"] floatValue] : 1;
   // NSLog(@"%f  %f  %f %f",r,g,b,alpha);
    return [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:alpha];
}

@end
