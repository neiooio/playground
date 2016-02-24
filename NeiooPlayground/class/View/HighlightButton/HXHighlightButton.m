//
//  HXHighlightButton.m
//  iBeacon
//
//  Created by Tim on 3/6/15.
//  Copyright (c) 2015 Herxun. All rights reserved.
//

#import "HXHighlightButton.h"

@interface HXHighlightButton ()
@property (strong, nonatomic) NSString *title;
@property (strong, nonatomic) UIColor *titleColor;
@property (strong, nonatomic) UIColor *buttonBackgroundColor;
@property (strong, nonatomic) UIColor *buttonBackgroundHighlightedColor;
@end

@implementation HXHighlightButton

- (id)initWithFrame:(CGRect)frame title:(NSString *)title titleColor:(UIColor *)titleColor backgroundColor:(UIColor *)backgroundColor backgroundHighlightedColor:(UIColor *)backgroundHighlightedColor
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.title = title;
        self.titleColor = titleColor;
        self.buttonBackgroundColor = backgroundColor;
        self.buttonBackgroundHighlightedColor = backgroundHighlightedColor;
        [self initView];
    }
    return self;
}

- (void)initView
{
    [self setTitle:self.title forState:UIControlStateNormal];
    self.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13.f];
    [self setTitleColor:self.titleColor forState:UIControlStateNormal];
    [self setTitleColor:self.titleColor forState:UIControlStateHighlighted];
    [self setBackgroundColor:self.backgroundColor];
    self.layer.cornerRadius = 2;
    [self sizeToFit];
    CGRect aFrame = self.frame;
    aFrame.size.width += 6 *2;
    aFrame.size.height += 7;
    self.frame = aFrame;
    [self addTarget:self action:@selector(buttonUpListener:) forControlEvents:UIControlEventTouchUpInside];
    [self addTarget:self action:@selector(buttonDownListener:) forControlEvents:UIControlEventTouchDown];
    [self addTarget:self action:@selector(buttonDownListener:) forControlEvents:UIControlEventTouchDragEnter];
    [self addTarget:self action:@selector(buttonUpListener:) forControlEvents:UIControlEventTouchUpOutside];
    [self addTarget:self action:@selector(buttonUpListener:) forControlEvents:UIControlEventTouchDragExit];
}

#pragma mark - Listener

- (void)buttonDownListener:(UIButton *)button
{
    self.backgroundColor = self.buttonBackgroundHighlightedColor;
}

- (void)buttonUpListener:(UIButton *)button
{
    self.backgroundColor = self.buttonBackgroundColor;
}

@end
