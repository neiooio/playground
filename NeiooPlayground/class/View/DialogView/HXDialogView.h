//
//  HXDialogView.h
//  iBeacon
//
//  Created by Jefferson on 2015/3/5.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXDialogView;

typedef enum {
    HXImageAlignVTop,
    HXImageAlignVCenter,
    HXImageAlignVBottom
} HXImageAlignV;

typedef enum {
    HXImageAlignHLeft,
    HXImageAlignHCenter,
    HXImageAlignHRight
} HXImageAlignH;

@protocol HXDialogViewDelegate <NSObject>
@optional
- (void)didDialogButtonTapped:(HXDialogView *)dialog;
@end

@interface HXDialogView : UIView
@property (weak, nonatomic) id<HXDialogViewDelegate> delegate;

- (id)initWithView:(UIView *)view;
- (id)initWithTitle:(NSString *)title message:(NSString *)message imageUrl:(NSString *)imageUrl;

- (id)initImageDialogWithUrl:(NSString *)url
               verticalAlign:(HXImageAlignV)alignV
             horizontalAlign:(HXImageAlignH)alignH
                      scaleW:(CGFloat)scaleW
                      scaleH:(CGFloat)scaleH;

- (void)showWithOpacityAnimation;
- (void)dismissWithOpacityAnimation;

- (void)show;
- (void)showInViewController:(UIViewController *)viewController;

- (void)dismiss;
- (void)dismissCompletion:(void (^) (BOOL complete))completion;

@end
