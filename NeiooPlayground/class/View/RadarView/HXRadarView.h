//
//  HXRadarView.h
//  iBeacon
//
//  Created by Tim on 3/6/15.
//  Copyright (c) 2015 Herxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXRadarView : UIView

- (void)addCenterImageView:(UIImageView *)centerImage;
- (void)updateCenterImage:(UIImage *)image;
- (void)updateCircleColor:(UIColor *)color;
- (void)removeCenterImageView;
- (void)circleBroadcastAnimationOn:(BOOL)animationOn;

- (void)startAnimation;
- (void)stopAnimation;

- (void)scanLineAnimationWithDuration:(NSUInteger)duration;

- (id)initWithFrame:(CGRect)frame circleColor:(UIColor *)circleColor centerImage:(UIImage *)centerImage;
@end
