//
//  HXMenuViewController.m
//  NeiooPlayground
//
//  Created by hsujahhu on 2015/7/23.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import "HXMenuViewController.h"

#import "HXProximityViewController.h"
#import "HXShakeViewController.h"
#import "HXTargetViewController.h"

#import "HXMenuButton.h"
#import "HXTriggerManager.h"

#import "UIColor+CustomColor.h"
#import "Config.h"

#import <JBWebViewController/JBWebViewController.h>

#define BUTTON_TITLE_1 @"Proximity\rMarketing"
#define BUTTON_TITLE_2 @"Shake"
#define BUTTON_TITLE_3 @"Target\rMarketing"
#define BUTTON_TITLE_4 @"Buy\rNeioo Beacon"

#define BUTTON_IMAGE_1 [UIImage imageNamed:@"menuicon_proximity"]
#define BUTTON_IMAGE_2 [UIImage imageNamed:@"menuicon_shake"]
#define BUTTON_IMAGE_3 [UIImage imageNamed:@"menuicon_target"]
#define BUTTON_IMAGE_4 [UIImage imageNamed:@"menuicon_buy"]

#define NEIOO_WEB_URL  @"http://neioo.io"
#define BUTTON_DIAMETER  kScreenWidth * .6875
#define VIEW_HEIGHT self.view.frame.size.height - 64

typedef enum {
    HXMenuListOptionProximityMarketing,
    HXMenuListOptionShake,
    HXMenuListOptionTargetMarketing,
    HXMenuListOptionBuyNeiooBeacon
} HXMenuListOption;

@interface HXMenuViewController ()

@end

@implementation HXMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

- (void)viewWillAppear:(BOOL)animated
{
    if ([HXTriggerManager manager].delegate) {
        [HXTriggerManager manager].delegate = nil;
        [[HXTriggerManager manager] stopTrigger];
    }
}

#pragma mark - Init

- (void)initView
{
    self.navigationItem.titleView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"nav_logo"]];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@""
                                                                             style:UIBarButtonItemStylePlain
                                                                            target:nil action:nil];
    
    
    CGFloat buttonCenterOffset = (VIEW_HEIGHT - (BUTTON_DIAMETER/2 - 44) * 2) / 3;
    
    //proximity marketing button
    ////////////////////////////
    
    HXMenuButton *button1 = [[HXMenuButton alloc]initWithFrame:CGRectMake(-24, -44, BUTTON_DIAMETER, BUTTON_DIAMETER)
                                                         title:BUTTON_TITLE_1
                                                         image:BUTTON_IMAGE_1
                                               backgroundColor:[UIColor color1]
                                                    titleColor:[UIColor color6]
                                                   rippleColor:[[UIColor color5] colorWithAlphaComponent:0.1]];
    button1.tag = HXMenuListOptionProximityMarketing;
    [button1 addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    //shake button
    ////////////////////////////
    
    HXMenuButton *button2 = [[HXMenuButton alloc]initWithFrame:CGRectMake(kScreenWidth - BUTTON_DIAMETER + 24, 0, BUTTON_DIAMETER, BUTTON_DIAMETER)
                                                         title:BUTTON_TITLE_2
                                                         image:BUTTON_IMAGE_2
                                               backgroundColor:[UIColor color15]
                                                    titleColor:[UIColor color6]
                                                   rippleColor:[[UIColor color5] colorWithAlphaComponent:0.1]];
    button2.center = CGPointMake(button2.center.x, button1.center.y + buttonCenterOffset);
    
    button2.tag = HXMenuListOptionShake;
    [button2 addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    //target marketing button
    ////////////////////////////
    
    HXMenuButton *button3 = [[HXMenuButton alloc]initWithFrame:CGRectMake(-24, 0, BUTTON_DIAMETER, BUTTON_DIAMETER)
                                                         title:BUTTON_TITLE_3
                                                         image:BUTTON_IMAGE_3
                                               backgroundColor:[UIColor color14]
                                                    titleColor:[UIColor color6]
                                                   rippleColor:[[UIColor color5] colorWithAlphaComponent:0.1]];
    button3.center = CGPointMake(button3.center.x, button1.center.y + buttonCenterOffset * 2);
    
    button3.tag = HXMenuListOptionTargetMarketing;
    [button3 addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    //buy neioo beacon button
    ////////////////////////////
    
    HXMenuButton *button4 = [[HXMenuButton alloc]initWithFrame:CGRectMake(kScreenWidth - BUTTON_DIAMETER + 24,
                                                                          VIEW_HEIGHT - BUTTON_DIAMETER + 44 , BUTTON_DIAMETER, BUTTON_DIAMETER)
                                                         title:BUTTON_TITLE_4
                                                         image:BUTTON_IMAGE_4
                                               backgroundColor:[UIColor color16]
                                                    titleColor:[UIColor color6]
                                                   rippleColor:[[UIColor color5] colorWithAlphaComponent:0.1]];
    button4.tag = HXMenuListOptionBuyNeiooBeacon;
    [button4 addTarget:self action:@selector(showDetail:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
}

#pragma mark - Listener

- (void)showDetail:(HXMenuButton *)sender
{
    switch (sender.tag) {
            
        case HXMenuListOptionProximityMarketing:{
            
            HXProximityViewController *vc = [[HXProximityViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case HXMenuListOptionShake:{
            
            HXShakeViewController *vc = [[HXShakeViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case HXMenuListOptionTargetMarketing:{
            
            HXTargetViewController *vc = [[HXTargetViewController alloc]init];
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case HXMenuListOptionBuyNeiooBeacon:{
            
            JBWebViewController *vc = [[JBWebViewController alloc]initWithUrl:[NSURL URLWithString:NEIOO_WEB_URL]];
            [vc show];
            break;
        }
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
