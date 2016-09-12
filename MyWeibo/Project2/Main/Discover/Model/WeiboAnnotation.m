//
//  WeiboAnnotation.m
//  Project2
//
//  Created by mac on 16/8/15.
//  Copyright © 2016年 Fxxx. All rights reserved.
//

#import "WeiboAnnotation.h"

@implementation WeiboAnnotation

-(void)setModel:(WeiboModel *)model{
    _model = model;
    
    NSDictionary * geo = _model.geo;
    NSArray *geoArr= geo[@"coordinates"];
    if (geoArr.count == 2) {
        NSString * lat = [geoArr firstObject];
        NSString * lon = [geoArr lastObject];
        self.coordinate = CLLocationCoordinate2DMake([lat doubleValue], [lon doubleValue]);
    }
    
}

@end
