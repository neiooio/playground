//
//  HXAlertView.h
//  BNextMeet
//
//  Created by hsujahhu on 2015/6/2.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HXAlertView;
@protocol HXAlertViewDelegate <NSObject>
@optional

// Called when a button is clicked. The view will be automatically dismissed after this call returns
- (void)alertView:(HXAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface HXAlertView : UIView
@property (weak, nonatomic) id<HXAlertViewDelegate> delegate;
- (instancetype)initWithTitle:(NSString *)title message:(NSString *)message delegate:(id /*<HXAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSString *)otherButtonTitles, ...;

- (void)show;
- (void)dismiss;
@end