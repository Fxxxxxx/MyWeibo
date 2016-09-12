//
//  FaceScrollView.h
//  Project2
//
//  Created by Fxxx on 16/8/13.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import <UIKit/UIKit.h>
#define ItemSize (kScreenWidth / 7)
#define FaceSize 30

@protocol FaceViewDelegate <NSObject>

- (void) selectFaceChs:(NSString *)faceName;

@end

@interface FaceView : UIView
@property (nonatomic,strong) NSArray * faceArr;
@property (nonatomic,assign) id<FaceViewDelegate> delegate;
@end
