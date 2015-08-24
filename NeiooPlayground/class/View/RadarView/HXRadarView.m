//
//  HXRadarView.m
//  iBeacon
//
//  Created by Tim on 3/6/15.
//  Copyright (c) 2015 Herxun. All rights reserved.
//

#import "HXRadarView.h"
#import "UIColor+CustomColor.h"

@interface HXRadarView ()
@property (strong, nonatomic) UIColor *circleColor;
@property (strong, nonatomic) UIView *circle1;
@property (strong, nonatomic) UIView *circle2;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIImage *centerImage;
@property (strong, nonatomic) UIImageView *scanLine;
@end

@implementation HXRadarView

#pragma mark - View

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        [self initView];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame circleColor:(UIColor *)circleColor centerImage:(UIImage *)centerImage
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.circleColor = circleColor;
        self.centerImage = centerImage;
        [self initView];
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [UIColor clearColor];
    
    self.scanLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"signal"]];
    self.scanLine.frame = self.bounds;
    [self addSubview:self.scanLine];
    
    self.centerImageView = [[UIImageView alloc]initWithImage:_centerImage];
    CGRect frame = self.centerImageView.frame;
    frame.size.width = 56;
    frame.size.height = 56;
    self.centerImageView.frame = frame;
    self.centerImageView.layer.cornerRadius = 28.f;
    self.centerImageView.layer.masksToBounds = YES;
    self.centerImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:self.centerImageView];
    
}

- (void)startAnimation
{
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = 4;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.scanLine.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    
    [self circleAnimation];
    [self circleBroadcastAnimationOn:YES];
}

- (void)scanLineAnimationWithDuration:(NSUInteger)duration
{
    [self.scanLine.layer removeAllAnimations];
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
    rotationAnimation.duration = duration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.scanLine.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
}

- (void)circleAnimation
{
    if (!self.circle1)
    {
        self.circle1 = [[UIView alloc] initWithFrame:self.bounds];
        self.circle1.backgroundColor = _circleColor;
        self.circle1.layer.cornerRadius = 76;
        [self addSubview:self.circle1];
    }
    if (!self.circle2)
    {
        self.circle2 = [[UIView alloc] initWithFrame:self.bounds];
        self.circle2.backgroundColor = _circleColor;
        self.circle2.layer.cornerRadius = 76;
        [self addSubview:self.circle2];
    }
    
    self.circle1.alpha = 1;
    self.circle1.transform = CGAffineTransformMakeScale(0.01, 0.01);
    self.circle2.alpha = 1;
    self.circle2.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    [UIView animateWithDuration:3
                          delay:0
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                     animations:^{
                         self.circle1.alpha = 0;
                         self.circle1.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                     }];
    [UIView animateWithDuration:3
                          delay:2
                        options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionRepeat
                     animations:^{
                         self.circle2.alpha = 0;
                         self.circle2.transform = CGAffineTransformIdentity;
                     }
                     completion:^(BOOL finished) {
                     }];
}

#pragma mark - Public

- (void)stopAnimation
{
    [self.circle1.layer removeAllAnimations];
    [self.circle2.layer removeAllAnimations];
    [self.scanLine.layer removeAllAnimations];
}

- (void)addCenterImageView:(UIImageView *)centerImage
{
    self.centerImageView = centerImage;
    CGRect frame = self.centerImageView.frame;
    frame.size.width = 56;
    frame.size.height = 56;
    self.centerImageView.frame = frame;
    self.centerImageView.layer.cornerRadius = 28.f;
    self.centerImageView.layer.masksToBounds = YES;
    self.centerImageView.center = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    [self addSubview:self.centerImageView];
}

- (void)updateCenterImage:(UIImage *)image
{
    self.centerImageView.image = image;
}

- (void)updateCircleColor:(UIColor *)color
{
    self.circle1.backgroundColor = color;
    self.circle2.backgroundColor = color;
}

- (void)removeCenterImageView
{
    [self.centerImageView removeFromSuperview];
}

- (void)circleBroadcastAnimationOn:(BOOL)animationOn
{
    if (animationOn)
    {
        [self insertSubview:self.circle1 atIndex:0];
        [self insertSubview:self.circle2 atIndex:0];
    }
    else
    {
        [self.circle1 removeFromSuperview];
        [self.circle2 removeFromSuperview];
    }
}

@end
