//
//  WeiboModel.m
//  Project2
//
//  Created by mac on 16/8/5.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "WeiboModel.h"
#import "Common.h"
#import "WXLabel.h"
#import "YYModel.h"
#import "RegexKitLite.h"
@implementation WeiboModel


-(CGFloat)textHeight{
    
    return [WXLabel getTextHeight:16 width:kScreenWidth - 20 text:_text];
}

-(CGFloat)imageHeight{
    NSInteger lines = (_pic_urls.count + 2) / 3;
    return ((kScreenWidth - 40) / 3 + 10) * lines - 10;
}

-(CGFloat)reTextHeight{
    return [WXLabel getTextHeight:16 width:kScreenWidth - 40 text:_retweeted_status.text];
}

-(CGFloat)reImageHeight{
    
    NSInteger lines = (_retweeted_status.pic_urls.count + 2) / 3;
    return ((kScreenWidth - 60) / 3 + 10) * lines - 10;
}


- (BOOL)modelCustomTransformFromDictionary:(NSDictionary *)dic{
    
    NSString * regex = @"\\[\\w+\\]";
    NSArray * faceArr = [self.text componentsMatchedByRegex:regex];
    
    NSString * filePath = [[NSBundle mainBundle]pathForResource:@"emoticons" ofType:@"plist"];
    NSArray * pathArr = [NSArray arrayWithContentsOfFile:filePath];
    
    for (NSString * faceStr in faceArr) {
        NSString * s = [NSString stringWithFormat:@"chs = '%@'",faceStr];
        
        NSArray *result = [pathArr filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:s]];
        NSDictionary * faceDic = [result lastObject];
        
        NSString * imgName = faceDic[@"png"];
        NSString * imgurl = [NSString stringWithFormat:@"<image url = '%@'>",imgName];
        
        self.text = [self.text stringByReplacingOccurrencesOfString:faceStr withString:imgurl];
        
        
    }
    
    return YES;
}

@end
