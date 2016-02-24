//
//  HXNameEntryView.m
//  iBeacon
//
//  Created by Tim on 3/6/15.
//  Copyright (c) 2015 Herxun. All rights reserved.
//

#import <POP/POP.h>
#import "HXNameEntryView.h"
#import "UIColor+CustomColor.h"
#import "UILabel+customLabel.h"
#import "UIFont+customFont.h"
#import "HXHighlightButton.h"
#import "HXTextFieldWithUnderLine.h"
//#import "HXAppUtility.h"

@interface HXNameEntryView () <UITextFieldDelegate>
@property (strong, nonatomic) HXTextFieldWithUnderLine *nameTextfield;
@property CGFloat originalViewY;
@property (strong, nonatomic) UIView *nameView;
@property (strong, nonatomic) HXHighlightButton *button;
@end

@implementation HXNameEntryView


- (id)initWithFrame:(CGRect)frame delegate:(id<HXNameEntryViewDelegate>)delegate
{
    self = [super initWithFrame:frame];
    if (self)
    {
        self.delegate = delegate;
        [self initView];
        
        _originalViewY = self.frame.origin.y;
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillShow:)
                                                     name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillBeHidden:)
                                                     name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

- (void)initView
{
    self.layer.cornerRadius = 4;
    self.backgroundColor = [UIColor color6];
    
    UIView *topBackground = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 60)];
    topBackground.backgroundColor = [UIColor color14];
    [self addSubview:topBackground];
    
    UILabel *titleLabel =  [UILabel labelWithFrame:CGRectNull
                                              text:@"Enter your name"
                                     textAlignment:NSTextAlignmentLeft
                                         textColor:[UIColor color6]
                                              font:[UIFont helveticaNeueWithSize:18.f]
                                     numberOfLines:1];
    CGRect frame = titleLabel.frame;
    frame.origin.x = 18.f;
    frame.origin.y = topBackground.frame.size.height/2 - frame.size.height/2;
    titleLabel.frame = frame;
    [topBackground addSubview:titleLabel];
    
    self.nameView = [[UIView alloc] initWithFrame:CGRectMake(18.f,
                                                                18.f + topBackground.frame.origin.y + topBackground.bounds.size.height,
                                                                self.bounds.size.width - 18 *2,
                                                                56 + 18)];
    
    UILabel *nameTextLabel = [UILabel labelWithFrame:CGRectNull
                                                 text:@"Name"
                                        textAlignment:NSTextAlignmentLeft
                                            textColor:[UIColor color13]
                                                 font:[UIFont helveticaNeueLightWithSize:11]
                                        numberOfLines:1];
    [self.nameView addSubview:nameTextLabel];
    
    self.nameTextfield = [[HXTextFieldWithUnderLine alloc] initWithFrame:self.nameView.bounds
                                                     heightBelowUnderLine:18.f];
    self.nameTextfield.delegate = self;
    self.nameTextfield.font = [UIFont heitiLightWithSize:15.f];
    self.nameTextfield.textColor = [UIColor color13];
    self.nameTextfield.tintColor = [UIColor color14];
    self.nameTextfield.backgroundColor = [UIColor clearColor];
    self.nameTextfield.keyboardAppearance = UIKeyboardAppearanceDark;
    self.nameTextfield.returnKeyType = UIReturnKeyDone;
    [self.nameView addSubview:self.nameTextfield];
    
    [self addSubview:self.nameView];
    
    self.button = [[HXHighlightButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)
                                                                   title:@"Send"
                                                              titleColor:[UIColor color14]
                                                         backgroundColor:[UIColor color6]
                                              backgroundHighlightedColor:[UIColor color7]];
    frame = self.button.frame;
    frame.origin.x = self.bounds.size.width - 6.f - frame.size.width;
    frame.origin.y = self.bounds.size.height - 18 - frame.size.height;
    self.button.frame = frame;
    [self.button addTarget:self action:@selector(buttonListener:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.button];
    
    HXHighlightButton *backButton = [[HXHighlightButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)
                                                                       title:@"Cancel"
                                                                  titleColor:[UIColor color11]
                                                             backgroundColor:[UIColor color6]
                                                  backgroundHighlightedColor:[UIColor color7]];
    frame = backButton.frame;
    frame.origin.x = self.button.frame.origin.x - 6 - frame.size.width;
    frame.origin.y = self.button.frame.origin.y;
    backButton.frame = frame;
    [backButton addTarget:self action:@selector(backButtonListener:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:backButton];
}

#pragma mark - Public

- (void)textfieldResignFirstResponder
{
    [self.nameTextfield resignFirstResponder];
}

- (void)shakeTextfield
{
    self.button.userInteractionEnabled = NO;
    POPSpringAnimation *positionAnimation = [POPSpringAnimation animationWithPropertyNamed:kPOPLayerPositionX];
    positionAnimation.velocity = @500;
    positionAnimation.springBounciness = 20;
    [positionAnimation setCompletionBlock:^(POPAnimation *animation, BOOL finished) {
        self.button.userInteractionEnabled = YES;
    }];
    [self.nameView.layer pop_addAnimation:positionAnimation forKey:@"positionAnimation"];
}

#pragma mark - Listener

- (void)buttonListener:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if (self.delegate)
        [self.delegate nameEntryView:self dismissed:self.nameTextfield.text];
}

- (void)backButtonListener:(UIButton *)button
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    if ([self.delegate respondsToSelector:@selector(nameEntryViewBackButtonPressed:)])
        [self.delegate nameEntryViewBackButtonPressed:self];
}

#pragma mark - Notification

- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    
//    if ([HXAppUtility isiOS8])
//    {
//        CGRect frame = self.frame;
//        frame.origin.y = ([[UIScreen mainScreen] bounds].size.height -kbSize.height)/2 - frame.size.height/2;
//        self.frame = frame;
//    }
//    else
//    {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
//        [UIView setAnimationCurve:[aNotification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        
//        CGRect frame = self.frame;
//        frame.origin.y = ([[UIScreen mainScreen] bounds].size.height -kbSize.height)/2 - frame.size.height/2;
//        self.frame = frame;
//        
//        [UIView commitAnimations];
//    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[aNotification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect frame = self.frame;
    frame.origin.y = ([[UIScreen mainScreen] bounds].size.height -kbSize.height)/2 - frame.size.height/2;
    self.frame = frame;
    
    [UIView commitAnimations];
}

- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
//    if ([HXAppUtility isiOS8])
//    {
//        CGRect frame = self.frame;
//        frame.origin.y = [[UIScreen mainScreen] bounds].size.height/2 - frame.size.height/2;
//        self.frame = frame;
//    }
//    else
//    {
//        [UIView beginAnimations:nil context:NULL];
//        [UIView setAnimationDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
//        [UIView setAnimationCurve:[aNotification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]];
//        [UIView setAnimationBeginsFromCurrentState:YES];
//        
//        CGRect frame = self.frame;
//        frame.origin.y = [[UIScreen mainScreen] bounds].size.height/2 - frame.size.height/2;
//        self.frame = frame;
//        
//        [UIView commitAnimations];
//    }
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:[aNotification.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue]];
    [UIView setAnimationCurve:[aNotification.userInfo[UIKeyboardAnimationCurveUserInfoKey] unsignedIntegerValue]];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    CGRect frame = self.frame;
    frame.origin.y = [[UIScreen mainScreen] bounds].size.height/2 - frame.size.height/2;
    self.frame = frame;
    
    [UIView commitAnimations];
}

#pragma mark - UITextfieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self buttonListener:nil];
    if (textField.text.length)
    {
        [textField resignFirstResponder];
        return YES;
    }
    else
        return YES;
}

@end
