//
//  HXMenuButton.m
//  NeiooPlayground
//
//  Created by hsujahhu on 2015/7/23.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import "HXMenuButton.h"
#import "UIFont+customFont.h"

@interface HXMenuButton ()
@end

@implementation HXMenuButton

- (id)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image backgroundColor:(UIColor *)backgroundColor titleColor:(UIColor *)titleColor rippleColor:(UIColor *)rippleColor
{
    self = [super initWithFrame:frame raised:NO];
    if (self) {
        
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(60, 60, 0, 0)];
        label.textColor = titleColor;
        label.textAlignment = NSTextAlignmentLeft;
        label.numberOfLines = 0;
        label.font = [UIFont helveticaNeueLightWithSize:20];
        label.text = title;
        [label sizeToFit];
        [self addSubview:label];
        
        UIImageView *imageView = [[UIImageView alloc]initWithImage:image];
        imageView.frame = CGRectMake(60, label.frame.origin.y + label.frame.size.height + 6, 54, 38);
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
        
        [self setBackgroundColor:backgroundColor];
        self.cornerRadius = self.frame.size.width / 2;
        self.rippleFromTapLocation = YES;
        self.tapCircleColor = rippleColor;
        
    }
    return self;
}

@end
