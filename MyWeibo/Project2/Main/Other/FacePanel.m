//
//  FacePanel.m
//  Project2
//
//  Created by Fxxx on 16/8/13.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "FacePanel.h"
#import "Common.h"
#import "UIViewExt.h"
#import "FaceView.h"

@implementation FacePanel{
    UIPageControl * pageCtr;
    NSMutableArray * faceArr;
    UIScrollView * _scrollView;
}


-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.height = ItemSize * 4 + 20;
        self.width = kScreenWidth;
        //self.clipsToBounds = NO;
        [self _createPageView];
        
    }
    return self;
}

- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _faceView.height)];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = _faceView.size;
        _scrollView.delegate = self;
        _scrollView.clipsToBounds = NO;
        [self addSubview:_scrollView];
    }
    return _scrollView;
}

-(void)setFaceFileArr:(NSArray *)faceFileArr{
    _faceFileArr = faceFileArr;
    faceArr = [NSMutableArray array];
    NSMutableArray * face2D = [NSMutableArray array];
    for (NSDictionary * dic in _faceFileArr) {
        if (face2D.count < 28) {
            [face2D addObject:dic];
        }
        if (face2D.count == 28){
            [faceArr addObject:face2D];
            face2D = [NSMutableArray array];
        }
    }
    [faceArr addObject:face2D];
    pageCtr.numberOfPages = faceArr.count;
    self.faceView.faceArr = faceArr;
}

#pragma mark CreateSubviews---

- (FaceView *)faceView{
    if (_faceView == nil) {
        _faceView = [[FaceView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        
        [self.scrollView addSubview:_faceView];
    }
    return _faceView;
}
-(void) _createPageView{
    pageCtr = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    pageCtr.bottom = self.height;
    pageCtr.backgroundColor = [UIColor redColor];
    pageCtr.currentPageIndicatorTintColor = [UIColor greenColor];
    pageCtr.pageIndicatorTintColor = [UIColor blackColor];
    [self addSubview:pageCtr];
}

#pragma mark scrollViewDelegate------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView; {
    pageCtr.currentPage = scrollView.contentOffset.x / kScreenWidth;
}

@end
