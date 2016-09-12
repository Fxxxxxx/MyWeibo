//
//  WeiboCell.m
//  Project2
//
//  Created by mac on 16/8/5.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "WeiboCell.h"
#import "UIImageView+WebCache.h"
#import "WeiboModel.h"
#import "UserModel.h"
#import "Common.h"
#import "ThemeManager.h"
#import "NSDate+TimeAgo.h"
#import "WXPhotoBrowser.h"
#import "WXPhoto.h"

@interface WeiboCell ()
{
    NSArray * imgUrls;
    UIImageView * srcImageView;
}

@end

@implementation WeiboCell



- (void)awakeFromNib {
    [super awakeFromNib];
    self.UserImg.layer.cornerRadius = 5;
    self.UserImg.layer.borderColor = [UIColor grayColor].CGColor;
    self.UserImg.layer.borderWidth = .5;
    self.UserImg.layer.masksToBounds = YES;
    
}

- (WXLabel *)WeiboText{
    if (_WeiboText == nil) {
        _WeiboText = [[WXLabel alloc] initWithFrame:CGRectMake(10, 65, kScreenWidth-20, _weiboModel.textHeight)];
        _WeiboText.numberOfLines = 0;
        _WeiboText.font = [UIFont systemFontOfSize:16];
        _WeiboText.backgroundColor = [UIColor clearColor];
        _WeiboText.wxLabelDelegate = self;
        [self.contentView addSubview:_WeiboText];
    }
    return _WeiboText;
}

-(UICollectionView *)imgsView{
    if (_imgsView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kScreenWidth - 50) / 3, (kScreenWidth - 50) / 3);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _imgsView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.WeiboText.frame) + 5, kScreenWidth - 20, _weiboModel.imageHeight) collectionViewLayout:layout];
        _imgsView.delegate = self;
        _imgsView.dataSource = self;
        _imgsView.scrollEnabled = NO;
        _imgsView.backgroundColor = [UIColor clearColor];
        [_imgsView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"imgCell"];
    }
    return _imgsView;
}

- (UIView *)retweetedView{
    if (_retweetedView == nil) {
        _retweetedView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.WeiboText.frame) + 5, kScreenWidth-20, _weiboModel.reTextHeight + _weiboModel.reImageHeight + 20)];
        UIImage * bgimg = [[ThemeManager shareInstance]ThemeimageWithImageName:@"timeline_rt_border_9"];
        bgimg = [bgimg stretchableImageWithLeftCapWidth:25 topCapHeight:25];
        _retweetedView.image = bgimg;
        _retweetedView.userInteractionEnabled = YES;
        [self.contentView addSubview:_retweetedView];
    }
    
    return _retweetedView;
}

-(WXLabel *)reWeiboText{
    if (_reWeiboText == nil) {
        _reWeiboText = [[WXLabel alloc] initWithFrame:CGRectMake(10, 10, kScreenWidth - 40, _weiboModel.reTextHeight)];
        _reWeiboText.numberOfLines = 0;
        _reWeiboText.font = [UIFont systemFontOfSize:16];
        _reWeiboText.backgroundColor = [UIColor clearColor];
        _reWeiboText.wxLabelDelegate = self;
        [self.retweetedView addSubview:_reWeiboText];
        
    }
    return _reWeiboText;
}

-(UICollectionView *)reImgsView{
    if (_reImgsView == nil) {
        UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
        layout.itemSize = CGSizeMake((kScreenWidth - 60) / 3, (kScreenWidth - 60) / 3);
        layout.minimumLineSpacing = 10;
        layout.minimumInteritemSpacing = 10;
        _reImgsView = [[UICollectionView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(self.reWeiboText.frame) + 5, kScreenWidth - 40, _weiboModel.reImageHeight) collectionViewLayout:layout];
        _reImgsView.backgroundColor = [UIColor clearColor];
        _reImgsView.delegate = self;
        _reImgsView.dataSource = self;
        _reImgsView.scrollEnabled = NO;
        [_reImgsView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reimgCell"];
    }
    return _reImgsView;
}

- (void)setWeiboModel:(WeiboModel *)weiboModel{
    _weiboModel = weiboModel;
    self.UserImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 50, 50)];
    self.NikeName = [[UILabel alloc] initWithFrame:CGRectMake(70, 5, 100, 30)];
    self.NikeName.font = [UIFont systemFontOfSize:16];
    self.Time = [[UILabel alloc] initWithFrame:CGRectMake(70, 40, 100, 20)];
    self.Time.font = [UIFont systemFontOfSize:14];
    self.Time.text = [self reTime:_weiboModel.created_at];
    self.Source = [[UILabel alloc] initWithFrame:CGRectMake(kScreenWidth - 160, 15, 150, 30)];
    self.Source.font = [UIFont systemFontOfSize:14];
    self.Source.textAlignment = NSTextAlignmentRight;
    self.Source.text = [self reSource:_weiboModel.source];
    [self.contentView addSubview:_UserImg];
    [self.contentView addSubview:_NikeName];
    [self.contentView addSubview:_Time];
    [self.contentView addSubview:_Source];
    [_UserImg sd_setImageWithURL:[NSURL URLWithString:_weiboModel.user.profile_image_url]];
    _NikeName.text = _weiboModel.user.name;
    
    self.WeiboText.text = _weiboModel.text;
    //如果有转发微博
    
    if (_weiboModel.retweeted_status) {
        [_imgsView removeFromSuperview];
        self.reWeiboText.text = _weiboModel.retweeted_status.text;
        if (_weiboModel.retweeted_status.pic_urls.count > 0) {
            [self.retweetedView addSubview:self.reImgsView];
        }
        
    }else{
        [_reImgsView removeFromSuperview];
        [_retweetedView removeFromSuperview];
    
        if (_weiboModel.pic_urls.count > 0) {
            [self.contentView addSubview:self.imgsView];
        }
    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark ---collectionView
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section;{
    if (_weiboModel.retweeted_status != nil) {
        return _weiboModel.retweeted_status.pic_urls.count;
    }
    return self.weiboModel.pic_urls.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell * cell = nil;
    if (_weiboModel.retweeted_status != nil) {
        imgUrls = _weiboModel.retweeted_status.pic_urls;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reimgCell" forIndexPath:indexPath];
    }else{
        imgUrls = _weiboModel.pic_urls;
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imgCell" forIndexPath:indexPath];
    }
    
    UIImageView * imgview = [[UIImageView alloc] initWithFrame:cell.contentView.bounds];
    imgview.clipsToBounds = YES;
    imgview.backgroundColor = [UIColor clearColor];
    imgview.contentMode = UIViewContentModeScaleAspectFit;
    imgview.tag = 222;
    [imgview sd_setImageWithURL:[NSURL URLWithString:imgUrls[indexPath.row][@"thumbnail_pic"]]];
    [cell.contentView addSubview:imgview];
    
    return cell;
}

#pragma 选中collectionView的图片的事件
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath;{
    srcImageView = [[collectionView cellForItemAtIndexPath:indexPath].contentView viewWithTag:222];
    [WXPhotoBrowser showImageInView:self.window selectImageIndex:indexPath.row delegate:self];
}
//需要显示的图片个数
- (NSUInteger)numberOfPhotosInPhotoBrowser:(WXPhotoBrowser *)photoBrowser;{
    return imgUrls.count;
}

//返回需要显示的图片对应的Photo实例,通过Photo类指定大图的URL,以及原始的图片视图
- (WXPhoto *)photoBrowser:(WXPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index;{
    WXPhoto * photo = [[WXPhoto alloc] init];
    //原图
    photo.srcImageView = srcImageView;
    NSString * imgurl = imgUrls[index][@"thumbnail_pic"];
    imgurl = [imgurl stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"large"];
    //设置大图
    photo.url = [NSURL URLWithString:imgurl];
    
    return photo;
}

- (NSString *)reSource:(NSString *)src{
    //"<a href=\"http://app.weibo.com/t/feed/6vtZb0\" rel=\"nofollow\">微博 weibo.com</a>"
    if (src.length <= 0) {
        return nil;
    }
    NSInteger start = [src rangeOfString:@">"].location;
    NSInteger end = [src rangeOfString:@"<" options:NSBackwardsSearch].location;
    NSString * str = [src substringWithRange:NSMakeRange(start + 1, end - start - 1)];
    return str;
}

- (NSString *)reTime:(NSString *)src{
    //Thu Jan 10 13:37:59 +0800 2013
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"E M d HH:mm:ss Z yyyy"];
    [formatter setLocale:[NSLocale localeWithLocaleIdentifier:@"en_US"]];
    NSDate * date = [formatter dateFromString:src];
    return [date timeAgo];
}


#pragma mark -----------WXLabelDelegate------

//检索文本的正则表达式的字符串
- (NSString *)contentsOfRegexStringWithWXLabel:(WXLabel *)wxLabel{
    
    
    return @"@[\\w_-]{2,30}|#[^#]+#|http(s)?://(([a-zA-Z0-9._-])+(/)?)*";
}

//设置当前链接文本的颜色
- (UIColor *)linkColorWithWXLabel:(WXLabel *)wxLabel{
    
    return [UIColor blueColor];
    
}


//NSAttributedString.h 中文本属性key的说明
/*
 NSFontAttributeName                设置字体属性，默认值：字体：Helvetica(Neue) 字号：12
 NSForegroundColorAttributeNam      设置字体颜色，取值为 UIColor对象，默认值为黑色
 NSBackgroundColorAttributeName     设置字体所在区域背景颜色，取值为 UIColor对象，默认值为nil, 透明色
 NSLigatureAttributeName            设置连体属性，取值为NSNumber 对象(整数)，0 表示没有连体字符，1 表示使用默认的连体字符
 NSKernAttributeName                设定字符间距，取值为 NSNumber 对象（整数），正值间距加宽，负值间距变窄
 NSStrikethroughStyleAttributeName  设置删除线，取值为 NSNumber 对象（整数）
 NSStrikethroughColorAttributeName  设置删除线颜色，取值为 UIColor 对象，默认值为黑色
 NSUnderlineStyleAttributeName      设置下划线，取值为 NSNumber 对象（整数），枚举常量 NSUnderlineStyle中的值，与删除线类似
 NSUnderlineColorAttributeName      设置下划线颜色，取值为 UIColor 对象，默认值为黑色
 NSStrokeWidthAttributeName         设置笔画宽度，取值为 NSNumber 对象（整数），负值填充效果，正值中空效果
 NSStrokeColorAttributeName         填充部分颜色，不是字体颜色，取值为 UIColor 对象
 NSShadowAttributeName              设置阴影属性，取值为 NSShadow 对象
 NSTextEffectAttributeName          设置文本特殊效果，取值为 NSString 对象，目前只有图版印刷效果可用：
 NSBaselineOffsetAttributeName      设置基线偏移值，取值为 NSNumber （float）,正值上偏，负值下偏
 NSObliquenessAttributeName         设置字形倾斜度，取值为 NSNumber （float）,正值右倾，负值左倾
 NSExpansionAttributeName           设置文本横向拉伸属性，取值为 NSNumber （float）,正值横向拉伸文本，负值横向压缩文本
 NSWritingDirectionAttributeName    设置文字书写方向，从左向右书写或者从右向左书写
 NSVerticalGlyphFormAttributeName   设置文字排版方向，取值为 NSNumber 对象(整数)，0 表示横排文本，1 表示竖排文本
 NSLinkAttributeName                设置链接属性，点击后调用浏览器打开指定URL地址
 NSAttachmentAttributeName          设置文本附件,取值为NSTextAttachment对象,常用于文字图片混排
 NSParagraphStyleAttributeName      设置文本段落排版格式，取值为 NSParagraphStyle 对象
 */
//- (NSMutableAttributedString *)reText:(NSString *)src{
//    NSMutableAttributedString * str = [[NSMutableAttributedString alloc] initWithString:src];
//    
//    //正则表达式
//    NSString * regex = [NSString stringWithFormat:@"@[\\w_-]{2,30}|#[^#]+#|http(s)?://(([a-zA-Z0-9._-])+(/)?)*"];
//    NSRegularExpression * regular = [NSRegularExpression regularExpressionWithPattern:regex options:NSRegularExpressionCaseInsensitive error:nil];
//    NSArray * arr = [regular matchesInString:src options:NSMatchingReportProgress range:NSMakeRange(0, src.length)];
//    for (NSTextCheckingResult * result in arr) {
//        NSRange range = result.range;
//        [str addAttribute:NSForegroundColorAttributeName value:[UIColor blueColor] range:range];
//        [str addAttribute:NSLinkAttributeName value:@"http://www.baidu.com" range:range];
//    }
//    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSMakeRange(0, src.length)];
//    return str;
//}

@end
