//
//  HXDialogView.m
//  iBeacon
//
//  Created by Jefferson on 2015/3/5.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import "HXDialogView.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"
#import "UILabel+CustomLabel.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <POP/POP.h>

@interface HXDialogView()  <UIScrollViewDelegate>
@property (strong, nonatomic) UIView *dialogView;
@end

@implementation HXDialogView

- (id)initWithView:(UIView *)view
{
    self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    if (self)
    {
        self.backgroundColor = [[UIColor color5]colorWithAlphaComponent:0.8];
        view.center = self.center;
        [self addSubview:view];
        self.dialogView = view;
    }
    return self;
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message imageUrl:(NSString *)imageUrl
{
    self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    if (self)
    {
        self.backgroundColor = [[UIColor color5]colorWithAlphaComponent:0.8];
        self.dialogView = [self dialogViewWithTitle:title
                                            message:message
                                        buttonTitle:@"OK"
                                      imageFileName:@""
                                           imageUrl:imageUrl
                                              frame:CGRectMake(0, 0, 248, 341)
                                       buttonHidden:NO];
        self.dialogView.center = self.center;
        [self addSubview:self.dialogView];
    }
    return self;
}

- (id)initImageDialogWithUrl:(NSString *)url
               verticalAlign:(HXImageAlignV)alignV
             horizontalAlign:(HXImageAlignH)alignH
                      scaleW:(CGFloat)scaleW
                      scaleH:(CGFloat)scaleH
{
    self = [super initWithFrame:[[UIApplication sharedApplication] keyWindow].frame];
    if (self)
    {
        self.backgroundColor = [[UIColor color5]colorWithAlphaComponent:0.8];
        self.dialogView = [self imageDialogViewWithUrl:url
                                         verticalAlign:alignV
                                       horizontalAlign:alignH
                                                scaleW:scaleW
                                                scaleH:scaleH];
        [self addSubview:self.dialogView];
        
    }
    return self;
}

- (void)tapped:(UITapGestureRecognizer *)tap
{
    [self dismissWithOpacityAnimation];
}

- (UIImageView *)imageDialogViewWithUrl:(NSString *)url
                          verticalAlign:(HXImageAlignV)alignV
                        horizontalAlign:(HXImageAlignH)alignH
                                 scaleW:(CGFloat)scaleW
                                 scaleH:(CGFloat)scaleH
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width * scaleW, self.frame.size.height * scaleH)];
    imageView.backgroundColor = [UIColor color6];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    imageView.center = [self getCenterForImageWithImageView:imageView backgroundView:self AlignV:alignV alignH:alignH];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    [imageView addGestureRecognizer:tap];
    
    imageView.userInteractionEnabled = YES;
    
    [imageView sd_setImageWithURL:[NSURL URLWithString:url]
                 placeholderImage:nil
                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                            imageView.image = image;
                            
                        }];
    
    return imageView;
}

- (UIView *)dialogViewWithTitle:(NSString *)title
                        message:(NSString *)message
                    buttonTitle:(NSString *)buttonTitle
                  imageFileName:(NSString *)imageFileName
                       imageUrl:(NSString *)imageUrl
                          frame:(CGRect)frame
                   buttonHidden:(BOOL)buttonHidden
{
    UIView *dialogView = [[UIView alloc]initWithFrame:frame];
    UIImageView *imageView = [[UIImageView alloc]init];
    
    if (![imageFileName isEqualToString:@""]) {
        imageView.image = [UIImage imageNamed:imageFileName];
    }
    
    imageView.frame = CGRectMake(0, 0, 248, 177);
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    if (imageUrl) {
        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl]];
    }
    [dialogView addSubview:imageView];
    
    UILabel *titleLabel =  [UILabel labelWithFrame:CGRectMake(18.f, 177 + 18.f, 248 - 18.f *2, 18.f)
                                              text:title
                                     textAlignment:NSTextAlignmentLeft
                                         textColor:[UIColor color13]
                                              font:[UIFont heitiLightWithSize:18.f]
                                     numberOfLines:0];
    
    [dialogView addSubview:titleLabel];
    
    UILabel *messageLabel = [UILabel labelWithFrame:CGRectMake(titleLabel.frame.origin.x,
                                                               titleLabel.frame.origin.y + titleLabel.frame.size.height + 18,
                                                               titleLabel.bounds.size.width,
                                                               164 - titleLabel.bounds.size.height - 18.f *3)
                                               text:message
                                      textAlignment:NSTextAlignmentLeft
                                          textColor:[UIColor color12]
                                               font:[UIFont heitiLightWithSize:13.f]
                                      numberOfLines:0];
    
    [dialogView addSubview:messageLabel];
    
    if (buttonTitle.length)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button addTarget:self action:@selector(buttonListener:) forControlEvents:UIControlEventTouchUpInside];
        [button addTarget:self action:@selector(buttonDownListener:) forControlEvents:UIControlEventTouchDown];
        [button addTarget:self action:@selector(buttonDownListener:) forControlEvents:UIControlEventTouchDragEnter];
        [button addTarget:self action:@selector(buttonUpListener:) forControlEvents:UIControlEventTouchUpOutside];
        [button addTarget:self action:@selector(buttonUpListener:) forControlEvents:UIControlEventTouchDragExit];
        [button setTitle:buttonTitle forState:UIControlStateNormal];
        [button setTitle:buttonTitle forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor color15] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor color15] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont heitiLightWithSize:13.f];
        button.backgroundColor = [UIColor color6];
        button.layer.cornerRadius = 2.f;
        button.hidden = buttonHidden;
        [button sizeToFit];
        
        CGRect bframe = button.frame;
        bframe.size.width += 6.f *2;
        bframe.size.height = 30.f;
        bframe.origin.x = (dialogView.frame.size.width - bframe.size.width)/2;//248 - 6.f - bframe.size.width;
        bframe.origin.y = 341 - 12.f - bframe.size.height;
        button.frame = bframe;
        
        [dialogView addSubview:button];
    }
    dialogView.backgroundColor = [UIColor color6];
    return dialogView;
    
}

- (CGPoint)getCenterForImageWithImageView:(UIView *)imageView backgroundView:(UIView *)backgroundView AlignV:(HXImageAlignV)vAlign alignH:(HXImageAlignH)hAlign
{
    CGPoint imageCenter;
    if (hAlign == HXImageAlignHLeft)          imageCenter.x = CGRectGetWidth(imageView.frame)/2;
    else if (hAlign == HXImageAlignHCenter)   imageCenter.x = CGRectGetWidth(backgroundView.frame)/2; // - CGRectGetWidth(imageView.frame)/2;
    else if (hAlign == HXImageAlignHRight)    imageCenter.x = CGRectGetWidth(backgroundView.frame) - CGRectGetWidth(imageView.frame)/2;
    if (vAlign == HXImageAlignVTop)           imageCenter.y = CGRectGetHeight(imageView.frame)/2;
    else if (vAlign == HXImageAlignVCenter)   imageCenter.y = CGRectGetHeight(backgroundView.frame)/2; //; - CGRectGetHeight(imageView.frame)/2;
    else if (vAlign == HXImageAlignVBottom)   imageCenter.y = CGRectGetHeight(backgroundView.frame) - CGRectGetHeight(imageView.frame)/2;
    
    return imageCenter;
}

#pragma mark - Listener

- (void)buttonDownListener:(UIButton *)button
{
    button.backgroundColor = [UIColor color6];
}

- (void)buttonUpListener:(UIButton *)button
{
    button.backgroundColor = [UIColor color5];
}

- (void)buttonListener:(UIButton *)button
{
    button.backgroundColor = [UIColor color5];
    [self dismiss];
}

#pragma mark - ParentViewController

- (UIViewController*)viewController
{
    for (UIView* next = [self superview]; next; next = next.superview)
    {
        UIResponder* nextResponder = [next nextResponder];
        
        if ([nextResponder isKindOfClass:[UIViewController class]])
        {
            return (UIViewController*)nextResponder;
        }
    }
    
    return nil;
}

#pragma mark - Public

- (void)show
{
    UIWindow *displayWindow = [[[UIApplication sharedApplication] delegate] window];;
//    for (UIWindow *window in [[UIApplication sharedApplication] windows])
//    {
//        if (![[window class] isEqual:[UIWindow class]])
//        {
//            displayWindow = window;
//            break;
//        }
//    }
    [displayWindow addSubview:self];
    
    self.dialogView.center = CGPointMake(self.center.x, -self.center.y);
    self.layer.opacity = 0.0;
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(1);
    [opacityAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        
    }];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(self.center.y);
    positionAnimation.springBounciness = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        
    }];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.3, 1.3)];
    
    
    [self.dialogView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [self.dialogView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [self.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (void)showWithOpacityAnimation
{
    UIWindow *displayWindow = [[[UIApplication sharedApplication] delegate] window];;
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![[window class] isEqual:[UIWindow class]])
        {
            displayWindow = window;
            break;
        }
    }
    [displayWindow addSubview:self];
    
    self.layer.opacity = 0.0;
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(1);
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.8, 0.8)];
    
    [self.dialogView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [self.dialogView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [self.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (void)dismissWithOpacityAnimation
{
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0);
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 10;
    scaleAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.8, 0.8)];
    [scaleAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [self removeFromSuperview];
    }];
    
    [self.dialogView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [self.dialogView.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
    [self.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (void)dismiss
{
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.2;
    
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation easeInAnimation];
    offscreenAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    offscreenAnimation.toValue = @(self.frame.size.height*1.5f);
    offscreenAnimation.duration = 0.2f;
    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [self removeFromSuperview];
        if (self.delegate) {
            [self.delegate didDialogButtonTapped:self];
        }
        
    }];
    
    [self.dialogView.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
    [self.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (void)dismissCompletion:(void (^) (BOOL complete))completion;
{
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.2;
    
    POPBasicAnimation *offscreenAnimation = [POPBasicAnimation easeInAnimation];
    offscreenAnimation.property = [POPAnimatableProperty propertyWithName:kPOPLayerPositionY];
    offscreenAnimation.toValue = @(self.frame.size.height*1.5f);
    offscreenAnimation.duration = 0.2f;
    [offscreenAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        [self removeFromSuperview];
        if (self.delegate) {
            [self.delegate didDialogButtonTapped:self];
        }
    }];
    
    [offscreenAnimation setCompletionBlock:^(POPAnimation *ani, BOOL finished) {
        if (finished) {
            completion(YES);
        }
    }];
    [self.dialogView.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
    [self.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

- (void)showInViewController:(UIViewController *)viewController
{
    //    UIWindow *displayWindow = [[[UIApplication sharedApplication] delegate] window];;
    //    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    //    {
    //        if (![[window class] isEqual:[UIWindow class]])
    //        {
    //            displayWindow = window;
    //            break;
    //        }
    //    }
    //    [displayWindow addSubview:self];
    [viewController.view addSubview:self];
    self.dialogView.center = CGPointMake(self.center.x, -self.center.y);
    self.layer.opacity = 0.0;
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(1);
    [opacityAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        
    }];
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(self.center.y);
    positionAnimation.springBounciness = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        
    }];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.3, 1.3)];
    
    
    [self.dialogView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [self.dialogView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
    [self.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}

@end
