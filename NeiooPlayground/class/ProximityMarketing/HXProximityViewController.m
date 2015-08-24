//
//  HXProximityViewController.m
//  NeiooPlayground
//
//  Created by hsujahhu on 2015/7/23.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import "HXProximityViewController.h"
#import "HXRadarView.h"
#import "HXTriggerManager.h"

#import "UIColor+CustomColor.h"

@interface HXProximityViewController ()<HXTriggerManagerDelegate>
@property (strong, nonatomic) HXRadarView *radarView;
@end

@implementation HXProximityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [[HXTriggerManager manager] setupSenario:HXTriggeredSenarioProximity];
    [HXTriggerManager manager].delegate = self;
    [[HXTriggerManager manager] startTrigger];
    
    [self.radarView startAnimation];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Init

- (void)initView
{
    self.view.backgroundColor = [UIColor color6];
    
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_logo"]];
    self.navigationController.navigationBar.translucent = NO;
    
    self.radarView = [[HXRadarView alloc] initWithFrame:CGRectMake(self.view.bounds.size.width/2 - 152/2,
                                                                   (self.view.bounds.size.height - 152)/2 - 64, 152, 152)
                                            circleColor:[UIColor color5]
                                            centerImage:[UIImage imageNamed:@"phone_grey"]];
    [self.view addSubview:self.radarView];
    
}

#pragma mark - Trigger delegate

- (void)neioo:(Neioo *)neioo didEnterSpace:(NeiooSpace *)space
{
    [self.radarView updateCenterImage:[UIImage imageNamed:@"phone_green"]];
    [self.radarView updateCircleColor:[UIColor color1]];
}

#pragma mark - Application

- (void)applicationDidBecomActive:(NSNotification *)notificaiton
{
    [self.radarView startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
