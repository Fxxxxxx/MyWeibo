//
//  FaceScrollView.m
//  Project2
//
//  Created by Fxxx on 16/8/13.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "FaceView.h"
#import "Common.h"
#import "UIViewExt.h"
@implementation FaceView{
    NSDictionary * _selectDic;
    UIImageView * _selectImgView;
}

-(UIImageView *)selectImgView{
    if (_selectImgView == nil) {
        _selectImgView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _selectImgView.image = [UIImage imageNamed:@"emoticon_keyboard_magnifier.png"];
        [_selectImgView sizeToFit];
        _selectImgView.clipsToBounds = NO;
        [self addSubview:_selectImgView];
        UIImageView * face = [[UIImageView alloc] initWithFrame:CGRectMake((self.selectImgView.width - FaceSize) / 2, 15, FaceSize, FaceSize)];
        face.tag = 100;
        [_selectImgView addSubview:face];
    }
    return _selectImgView;
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.height = ItemSize * 4;
        self.width = kScreenWidth * 4;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    for (NSInteger i = 0; i < _faceArr.count; i++) {
        NSArray * face2D = _faceArr[i];
        NSInteger row = 0;
        NSInteger columm = 0;
        for (NSDictionary * faceDic in face2D) {
            UIImage * faceImg = [UIImage imageNamed:[faceDic objectForKey:@"png"]];
            [faceImg drawInRect:CGRectMake(columm * ItemSize + (ItemSize - FaceSize) / 2 + i * kScreenWidth, row * ItemSize + (ItemSize - FaceSize) / 2, FaceSize, FaceSize)];
            
            if (columm++ == 6) {
                columm = 0;
                row++;
            }
        }
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    UIScrollView * scrollView = (UIScrollView *)self.superview;
    scrollView.scrollEnabled = NO;
    self.selectImgView.hidden = NO;
    [self touchFace:point];
}
-(void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    [self touchFace:point];
}
-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    UITouch * touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    UIScrollView * scrollView = (UIScrollView *)self.superview;
    scrollView.scrollEnabled = YES;
    self.selectImgView.hidden = YES;
    [self touchFace:point];
    if (_selectDic) {
        [self.delegate selectFaceChs:[_selectDic objectForKey:@"chs"]];
    }
    
}
- (void)touchFace:(CGPoint)point{
    NSInteger page = point.x / kScreenWidth;
    NSInteger row = point.y / ItemSize;
    NSInteger column = (point.x - kScreenWidth * page) /ItemSize;
    NSInteger index = row * 7 + column;
    if (page == 3 && index > 19) {
        _selectDic = nil;
        return;
    }
    _selectDic = _faceArr[page][index];
    UIImageView * img = [self.selectImgView viewWithTag:100];
    img.image = [UIImage imageNamed:_selectDic[@"png"]];
    self.selectImgView.center = CGPointMake(column * ItemSize + ItemSize / 2 + page * kScreenWidth, row * ItemSize + ItemSize / 2 - self.selectImgView.height / 2);
}

@end
