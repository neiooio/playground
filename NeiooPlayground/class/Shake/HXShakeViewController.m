//
//  HXShakeViewController.m
//  NeiooPlayground
//
//  Created by hsujahhu on 2015/7/23.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import "HXShakeViewController.h"
#import "HXRadarView.h"
#import "HXDialogView.h"
#import "HXTriggerManager.h"

#import "UIColor+CustomColor.h"
#import <CoreMotion/CoreMotion.h>
#import <AudioToolbox/AudioToolbox.h>

@interface HXShakeViewController ()<HXTriggerManagerDelegate,HXDialogViewDelegate>
@property (strong, nonatomic) HXRadarView *radarView;
@property (strong, nonatomic) HXDialogView *shakeDialog;
@property (strong, nonatomic) HXDialogView *couponDialog;
@property (strong, nonatomic) CMMotionManager *motionManager;
@property (strong, nonatomic) UIGravityBehavior *gravityBeahvior;
@property BOOL playingFlag;
@end

@implementation HXShakeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initView];
    
    [HXTriggerManager manager].delegate = self;
    [[HXTriggerManager manager] startTrigger];
    [[HXTriggerManager manager] setupSenario:HXTriggeredSenarioShake];
    
    [self.radarView startAnimation];
    
    self.motionManager = [[CMMotionManager alloc] init];
    self.motionManager.accelerometerUpdateInterval = 0.1;
    if (!self.motionManager.isAccelerometerActive)
    {
        self.gravityBeahvior = [[UIGravityBehavior alloc] initWithItems:nil];
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue mainQueue]
                                                 withHandler:^(CMAccelerometerData *accelerometerData, NSError *error) {
                                                     CGFloat x = accelerometerData.acceleration.x;
                                                     CGFloat y = accelerometerData.acceleration.y;
                                                     self.gravityBeahvior.gravityDirection = CGVectorMake(x, -y);
                                                 }];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidBecomActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self.motionManager stopAccelerometerUpdates];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void)viewDidAppear:(BOOL)animated {
    [self becomeFirstResponder];
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
    [self.radarView updateCenterImage:[UIImage imageNamed:@"phone_yellow"]];
    [self.radarView updateCircleColor:[UIColor color15]];
}

- (void)inShakeRangeWithCampaign:(NeiooCampaign *)campaign
{
    if (!_shakeDialog) {
        
        NSDictionary *customField = [self parseCustomField:campaign.custom_field];
        
        _shakeDialog = [[HXDialogView alloc]initWithTitle:customField[@"title"]
                                                  message:customField[@"description"]
                                                 imageUrl:customField[@"image_url"]];
        _shakeDialog.delegate = self;
        [_shakeDialog show];
    }
    
}

- (void)outOfShakeRangeWithCampaign:(NeiooCampaign *)campaign
{
    if (_shakeDialog) {
        [_shakeDialog dismiss];
        _shakeDialog = nil;
    }
}

#pragma mark - HXDialogView delegate

- (void)didDialogButtonTapped:(HXDialogView *)dialog
{
    self.shakeDialog = nil;
}

#pragma mark - Application

- (void)applicationDidBecomActive:(NSNotification *)notificaiton
{
    [self.radarView startAnimation];
}

-(void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        // shaking has began.
        
        if (!self.shakeDialog) return;
            
        NSLog(@"SHAKE BEGIN");
        _playingFlag = YES;
        [self shakeSound];
    }
}

-(void)motionEnded:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    if (motion == UIEventSubtypeMotionShake)
    {
        
        if (!self.shakeDialog) return;
        
        // shaking has ended
        NSLog(@"SHAKE ENDED");
        
        [[HXTriggerManager manager] shake];
        
        _playingFlag = NO;
        
    }
}

- (void)motionCancelled:(UIEventSubtype)motion withEvent:(UIEvent *)event
{
    
    if (motion == UIEventSubtypeMotionShake)
    {
        NSLog(@"SHAKE CANCELLED");
        _playingFlag = NO;
        
    }
}

- (void)shakeSound
{
    if (_playingFlag)
    {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"shake" ofType:@"mp3"];
        SystemSoundID soundID;
        NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
        // play
        AudioServicesPlaySystemSound(soundID);
        
//        dispatch_queue_t myBackgroundQ = dispatch_queue_create("backgroundDelayQueue", NULL);
//        dispatch_time_t delay = dispatch_time(DISPATCH_TIME_NOW, .5 * NSEC_PER_SEC);
//        dispatch_after(delay, myBackgroundQ, ^(void){
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self shakeSound];
//            });
//        });
    }
    else
    {
        
    }
}

#pragma mark - Helper

- (NSDictionary *)parseCustomField:(NSString *)customField
{
    NSArray *customFields = [customField componentsSeparatedByString:@"|"];
    NSString *jsonStr = customFields[1];
    NSData *data = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    return json;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
