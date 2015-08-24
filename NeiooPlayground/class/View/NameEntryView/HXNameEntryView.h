//
//  HXNameEntryView.h
//  iBeacon
//
//  Created by Tim on 3/6/15.
//  Copyright (c) 2015 Herxun. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HXNameEntryView;
@protocol HXNameEntryViewDelegate <NSObject>
- (void)nameEntryView:(HXNameEntryView *)nameEntryView dismissed:(NSString *)nameText;
@optional
- (void)nameEntryViewBackButtonPressed:(HXNameEntryView *)nameEntryView;
@end

@interface HXNameEntryView : UIView
@property (weak, nonatomic) id<HXNameEntryViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame delegate:(id<HXNameEntryViewDelegate>)delegate;

- (void)textfieldResignFirstResponder;
- (void)shakeTextfield;

@end
