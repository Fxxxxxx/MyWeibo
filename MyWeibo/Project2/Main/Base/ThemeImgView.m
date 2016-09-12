//
//  ThemeImgView.m
//  Project2
//
//  Created by mac on 16/8/4.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "ThemeImgView.h"
#import "ThemeManager.h"
@implementation ThemeImgView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"ThemeChange" object:nil];
}

-(void)awakeFromNib{
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

- (void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    [self themeChange];
}

- (void) themeChange{
    self.image = [[ThemeManager shareInstance] ThemeimageWithImageName:_imgName];
}

@end
