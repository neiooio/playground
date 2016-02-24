//
//  HXAlertView.m
//  BNextMeet
//
//  Created by hsujahhu on 2015/6/2.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import "HXAlertView.h"
#import "UIColor+CustomColor.h"
#import "UIFont+CustomFont.h"
#import "UILabel+CustomLabel.h"
#import <POP/POP.h>
#define SCREEN_WIDTH [[UIScreen mainScreen] applicationFrame].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] applicationFrame].size.height
@interface HXAlertView()
@property (strong, nonatomic) UIView *alertView;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSString *buttonTitle;
@property (strong, nonatomic) NSString *cancelButtonTitle;
@end

@implementation HXAlertView

-(instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...
{
    self = [super initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT+22)];
    if (self) {
        self.delegate = delegate;
        self.message = message;
        self.buttonTitle = otherButtonTitles;
        self.cancelButtonTitle = cancelButtonTitle;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self initView];
        });
        
    }
    return self;
}

- (void)initView
{
    self.backgroundColor = [[UIColor color5]colorWithAlphaComponent:0.8];
    
    UILabel *messageLabel = [UILabel labelWithFrame:CGRectMake(18, 18, 260 - 18 * 2, 100)
                                               text:self.message
                                      textAlignment:NSTextAlignmentCenter
                                          textColor:[UIColor color13]
                                               font:[UIFont heitiLightWithSize:15.f]
                                      numberOfLines:0];
    [messageLabel sizeToFit];
    CGRect frame = messageLabel.frame;
    frame.size.width = 260 - 18 * 2;
    messageLabel.frame = frame;
    
    UIView *alertView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 260, 18*2 + 12 + 32 + messageLabel.frame.size.height)];
    alertView.center = self.center;
    alertView.layer.cornerRadius = 2;
    alertView.backgroundColor = [UIColor color6];
    [alertView addSubview:messageLabel];
    [self addSubview:alertView];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self bindButtonEvent:cancelButton];
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateNormal];
    [cancelButton setTitle:self.cancelButtonTitle forState:UIControlStateHighlighted];
    [cancelButton setTitleColor:[UIColor color10] forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor color10] forState:UIControlStateHighlighted];
    
    if (!self.buttonTitle) {
        [cancelButton setTitleColor:[UIColor color1] forState:UIControlStateNormal];
        [cancelButton setTitleColor:[UIColor color1] forState:UIControlStateHighlighted];
    }
    
    cancelButton.titleLabel.font = [UIFont heitiLightWithSize:13.f];
    cancelButton.backgroundColor = [UIColor color6];
    cancelButton.layer.cornerRadius = 2.f;
    cancelButton.tag = 0;
    [cancelButton sizeToFit];
    
    CGRect bframe = cancelButton.frame;
    bframe.size.width = 90;
    bframe.size.height = 32.f;
    bframe.origin.x = (260 - 90*2 - 12)/2 ;
    bframe.origin.y = alertView.frame.size.height - 12.f - bframe.size.height;
    cancelButton.frame = bframe;
    
    if (!self.buttonTitle) {
        CGRect bframe = cancelButton.frame;
        bframe.size.width = 90;
        bframe.size.height = 32.f;
        bframe.origin.x = (260 - 90)/2 ;
        bframe.origin.y = alertView.frame.size.height - 12.f - bframe.size.height;
        cancelButton.frame = bframe;
    }
    
    [alertView addSubview:cancelButton];
    
    if (self.buttonTitle) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        [self bindButtonEvent:button];
        [button setTitle:self.buttonTitle forState:UIControlStateNormal];
        [button setTitle:self.buttonTitle forState:UIControlStateHighlighted];
        [button setTitleColor:[UIColor color1] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor color1] forState:UIControlStateHighlighted];
        button.titleLabel.font = [UIFont heitiLightWithSize:13.f];
        button.backgroundColor = [UIColor color6];
        button.layer.cornerRadius = 2.f;
        button.tag = 1;
        [button sizeToFit];
        
        bframe = button.frame;
        bframe.size.width = 90;
        bframe.size.height = 32.f;
        bframe.origin.x = (260 - 90*2 - 12)/2 + 90 + 12;
        bframe.origin.y = alertView.frame.size.height - 12.f - bframe.size.height;
        button.frame = bframe;
        
        [alertView addSubview:button];
    }
    
    
    self.alertView = alertView;
}

- (void)bindButtonEvent:(UIButton *)button
{
    [button addTarget:self action:@selector(buttonListener:) forControlEvents:UIControlEventTouchUpInside];
    [button addTarget:self action:@selector(buttonDownListener:) forControlEvents:UIControlEventTouchDown];
    [button addTarget:self action:@selector(buttonDownListener:) forControlEvents:UIControlEventTouchDragEnter];
    [button addTarget:self action:@selector(buttonUpListener:) forControlEvents:UIControlEventTouchUpOutside];
    [button addTarget:self action:@selector(buttonUpListener:) forControlEvents:UIControlEventTouchDragExit];
}

#pragma mark - Listener

- (void)buttonDownListener:(UIButton *)button
{
    button.backgroundColor = [UIColor color7];
}

- (void)buttonUpListener:(UIButton *)button
{
    button.backgroundColor = [UIColor color6];
}

- (void)buttonListener:(UIButton *)button
{
    if (self.delegate)
        [self.delegate alertView:self clickedButtonAtIndex:button.tag];
    
    button.backgroundColor = [UIColor color6];
    [self dismiss];
}

- (void)show
{
    UIWindow *displayWindow = [[[UIApplication sharedApplication] delegate] window];
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        if (![[window class] isEqual:[UIWindow class]])
        {
            displayWindow = window;
            break;
        }
    }
    [displayWindow addSubview:self];
    
    self.alertView.center = CGPointMake(self.center.x, -self.center.y);
    self.layer.opacity = 0.0;
    
    POPBasicAnimation *opacityAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPLayerOpacity];
    opacityAnimation.toValue = @(1);
    
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionY];
    positionAnimation.toValue = @(self.center.y);
    positionAnimation.springBounciness = 10;
    [positionAnimation setCompletionBlock:^(POPAnimation *anim, BOOL finished) {
        
    }];
    
    POPSpringAnimation *scaleAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerScaleXY];
    scaleAnimation.springBounciness = 20;
    scaleAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(1.3, 1.3)];
    
    
    [self.alertView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
    [self.alertView.layer pop_addAnimation:scaleAnimation forKey:@"scaleAnimation"];
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
            
        }
    }];
    
    [self.alertView.layer pop_addAnimation:offscreenAnimation forKey:@"offscreenAnimation"];
    [self.layer pop_addAnimation:opacityAnimation forKey:@"opacityAnimation"];
}
@end
