//
//  ThemeLabel.m
//  Project2
//
//  Created by mac on 16/8/4.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "ThemeLabel.h"
#import "ThemeManager.h"
@implementation ThemeLabel

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ThemeChange" object:nil];
}
- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange) name:@"ThemeChange" object:nil];
    
}
- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChange) name:@"ThemeChange" object:nil];
    }
    return self;
}

-(void)setColorName:(NSString *)ColorName{
    _ColorName = ColorName;
    [self themeChange];
}

- (void) themeChange{
    self.textColor = [[ThemeManager shareInstance] ThemeColorWithColorName:_ColorName];
}
@end
