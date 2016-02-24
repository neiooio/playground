//
//  HXTriggerManager.h
//  NeiooTester
//
//  Created by hsujahhu on 2015/7/24.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Neioo.h"

@protocol HXTriggerManagerDelegate <NSObject>
@end

@interface HXTriggerManager : NSObject
@property (strong,nonatomic) id<HXTriggerManagerDelegate> delegate;
@property (strong,nonatomic) NeiooCampaign *campaignFromNotification;
+ (HXTriggerManager *)manager;
- (void)triggerCampaign:(NeiooCampaign *)campaign;
- (void)shake;
@end
