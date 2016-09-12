//
//  FacePanel.h
//  Project2
//
//  Created by Fxxx on 16/8/13.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FaceView;
@interface FacePanel : UIView<UIScrollViewDelegate>
@property (nonatomic,strong) FaceView * faceView;
@property (nonatomic,strong) NSArray * faceFileArr;
@property (nonatomic,assign) NSString * selectFace;
@end
