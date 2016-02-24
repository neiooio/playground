//
//  HXTextFieldWithUnderLine.m
//  iBeacon
//
//  Created by Tim on 2/25/15.
//  Copyright (c) 2015 Herxun. All rights reserved.
//

#import "HXTextFieldWithUnderLine.h"
#import "UIColor+CustomColor.h"

@interface HXTextFieldWithUnderLine ()
@property (strong, nonatomic) UIImageView *underLine;
@property (strong, nonatomic) UIImageView *activeUnderLine;

@end

@implementation HXTextFieldWithUnderLine

- (id)initWithFrame:(CGRect)frame heightBelowUnderLine:(CGFloat)heightBelowUnderLine
{
    self = [super initWithFrame:frame];
    if (self)
    {
        CGSize size = CGSizeMake(self.bounds.size.width, 2.f);
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 1.f;
        [[UIColor color8] setStroke];
        [path moveToPoint:CGPointMake(0.5, size.height/2)];
        [path addLineToPoint:CGPointMake(size.width -0.5, size.height/2)];
        [path stroke];
        self.underLine = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
        UIGraphicsEndImageContext();
        
        frame = self.underLine.frame;
        frame.origin.x = 0;
        frame.origin.y = self.bounds.size.height - size.height - heightBelowUnderLine;
        self.underLine.frame = frame;
        [self addSubview:self.underLine];
        
        UIGraphicsBeginImageContextWithOptions(size, NO, 0);
//        UIBezierPath *path = [UIBezierPath bezierPath];
        path.lineWidth = 2.f;
        [[UIColor color14] setStroke];
        [path moveToPoint:CGPointMake(0.5, size.height/2)];
        [path addLineToPoint:CGPointMake(size.width -0.5, size.height/2)];
        [path stroke];
        self.activeUnderLine = [[UIImageView alloc] initWithImage:UIGraphicsGetImageFromCurrentImageContext()];
        UIGraphicsEndImageContext();
        
        self.activeUnderLine.frame = self.underLine.frame;
        [self addSubview:self.activeUnderLine];
        self.activeUnderLine.alpha = 0;
        [self addSubview:self.activeUnderLine];
        
    }
    return self;
}

//- (CGRect)textRectForBounds:(CGRect)bounds
//{
//    return CGRectInset(bounds, 10, 10);
//}
//
//- (CGRect)editingRectForBounds:(CGRect)bounds
//{
//    return CGRectInset(bounds, 10, 10);
//}
//
//- (CGRect)placeholderRectForBounds:(CGRect)bounds
//{
//    return CGRectInset(bounds, 10, 10);
//}

- (BOOL)becomeFirstResponder
{
    [super becomeFirstResponder];
    self.activeUnderLine.alpha = 1;
    self.underLine.alpha = 0;
    return YES;
}

- (BOOL)resignFirstResponder
{
    [super resignFirstResponder];
    
    self.activeUnderLine.alpha = 0;
    self.underLine.alpha = 1;
    return YES;
}

@end
