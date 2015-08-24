//
//  HXMenuButton.h
//  NeiooPlayground
//
//  Created by hsujahhu on 2015/7/23.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import "BFPaperButton.h"
#import <UIKit/UIKit.h>

@interface HXMenuButton : BFPaperButton

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
              image:(UIImage *)image
    backgroundColor:(UIColor *)backgroundColor
         titleColor:(UIColor *)titleColor
        rippleColor:(UIColor *)rippleColor;
@end
