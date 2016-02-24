//
//  HXTargetViewController.m
//  NeiooPlayground
//
//  Created by hsujahhu on 2015/7/23.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import "HXTargetViewController.h"
#import "HXRadarView.h"
#import "HXDialogView.h"
#import "HXNameEntryView.h"
#import "HXTriggerManager.h"
#import "HXAppUtility.h"

#import "UIColor+CustomColor.h"
#import "UIFont+customFont.h"
#import "Config.h"

@interface HXTargetViewController ()<HXTriggerManagerDelegate,HXNameEntryViewDelegate,NeiooDelegate>
@property (strong, nonatomic) HXRadarView *radarView;
@property (strong, nonatomic) HXDialogView *nameEntryDialog;
@property (strong, nonatomic) UILabel *nameLabel;
@property (strong, nonatomic) UIButton *addNameButton;
@end

@implementation HXTargetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    [self showNameEntryDialog];
    
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

- (void)initNeioo
{
    [[Neioo shared] setDelegate:self];
    [[Neioo shared] clearCriteriaData];
    [[Neioo shared] disable];
    
#ifdef NEIOO_BEACON_UUID
    [[Neioo shared]enableWithMonitorRegion:[[CLBeaconRegion alloc] initWithProximityUUID:
                                            [[NSUUID alloc]initWithUUIDString:NEIOO_BEACON_UUID]
                                                                              identifier:@"Neioo Tester"]];
#endif
    
#ifndef NEIOO_BEACON_UUID
    [[Neioo shared] enable];
#endif
}

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
    
    self.nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(16, self.radarView.frame.origin.y - 16 - 15, kScreenWidth - 32, 15)];
    self.nameLabel.font = [UIFont helveticaNeueLightWithSize:15];
    self.nameLabel.textColor = [UIColor color12];
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    self.nameLabel.text = @"";
    [self.view addSubview:_nameLabel];
    
    self.addNameButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.addNameButton addTarget:self action:@selector(addNameButtonTapped) forControlEvents:UIControlEventTouchUpInside];
    [self.addNameButton setBackgroundImage:[HXAppUtility imageWithColor:[UIColor color9]] forState:UIControlStateNormal];
    [self.addNameButton setBackgroundImage:[HXAppUtility imageWithColor:[[UIColor color9] colorWithAlphaComponent:0.6]] forState:UIControlStateHighlighted];
    [self.addNameButton setTitle:@"Add your name" forState:UIControlStateNormal];
    [self.addNameButton setTitleColor:[UIColor color12] forState:UIControlStateNormal];
    self.addNameButton.titleLabel.font = [UIFont helveticaNeueWithSize:15];
    self.addNameButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.addNameButton.frame = CGRectMake(32, self.view.frame.size.height - 72 - 64 - 40, kScreenWidth - 64, 40);
    self.addNameButton.layer.cornerRadius = 20;
    self.addNameButton.layer.masksToBounds = YES;
    self.addNameButton.clipsToBounds = YES;
    self.addNameButton.hidden = YES;
    [self.view addSubview:self.addNameButton];
    
}

- (void)showNameEntryDialog
{
    self.nameEntryDialog = [[HXDialogView alloc] initWithView:[[HXNameEntryView alloc] initWithFrame:CGRectMake(0, 0, 248, 60 + 18 + 56 + 18 + 32 + 18) delegate:self]];
    [self.nameEntryDialog show];
}

#pragma mark - Listener

- (void)addNameButtonTapped
{
    [self showNameEntryDialog];
    [self.addNameButton setHidden:YES];
}

#pragma mark - HXNameEntryView delegate

- (void)nameEntryView:(HXNameEntryView *)nameEntryView dismissed:(NSString *)nameText
{
    if ([HXAppUtility removeWhitespace:nameText].length)
    {
        [self.radarView startAnimation];
        
        [self.nameEntryDialog dismiss];
        self.nameLabel.text = nameText;
        
        [HXTriggerManager manager].delegate = self;
        
        [self initNeioo];
        [[Neioo shared] setCriteriaData:nameText forKey:@"name"];
        
    }
    
}

- (void)nameEntryViewBackButtonPressed:(HXNameEntryView *)nameEntryView
{
    self.addNameButton.hidden = NO;
    [self.nameEntryDialog dismiss];
}


#pragma mark - Trigger delegate

- (void)neioo:(Neioo *)neioo didEnterSpace:(NeiooSpace *)space
{
    [self.radarView updateCenterImage:[UIImage imageNamed:@"phone_blue"]];
    [self.radarView updateCircleColor:[UIColor color14]];
}

- (void)neioo:(Neioo *)neioo didLeaveSpace:(NeiooSpace *)space
{
    [self.radarView updateCenterImage:[UIImage imageNamed:@"phone_grey"]];
    [self.radarView updateCircleColor:[UIColor color5]];
}

- (void)campaignTriggered:(NeiooCampaign *)campaign beacon:(NeiooBeacon *)beacon
{
    if (!campaign.criterias) return;
    if (!campaign.criterias.count) return;
    [[HXTriggerManager manager] triggerCampaign:campaign];
}

#pragma mark - Application

- (void)applicationDidBecomActive:(NSNotification *)notificaiton
{
    [self.radarView circleBroadcastAnimationOn:YES];
    [self.radarView startAnimation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
