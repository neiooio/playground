//
//  HXTriggerManager.h
//  NeiooTester
//
//  Created by hsujahhu on 2015/7/24.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Neioo.h"

typedef enum {
    HXTriggeredSenarioProximity,
    HXTriggeredSenarioTarget,
    HXTriggeredSenarioShake
} HXTriggeredSenario;

@protocol HXTriggerManagerDelegate <NSObject>
@optional
- (void)campaignTriggered:(NeiooCampaign *)campaign beacon:(NeiooBeacon *)beacon;
- (void)inShakeRangeWithCampaign:(NeiooCampaign *)campaign;
- (void)outOfShakeRangeWithCampaign:(NeiooCampaign *)campaign;
- (void)neioo:(Neioo *)neioo didEnterSpace:(NeiooSpace *)space;
- (void)neioo:(Neioo *)neioo didLeaveSpace:(NeiooSpace *)space;
@end

@interface HXTriggerManager : NSObject
@property (strong,nonatomic) id<HXTriggerManagerDelegate> delegate;

+ (HXTriggerManager *)manager;
- (void)setupSenario:(HXTriggeredSenario)senario;
- (void)shake;
- (void)startTrigger;
- (void)stopTrigger;
@end
