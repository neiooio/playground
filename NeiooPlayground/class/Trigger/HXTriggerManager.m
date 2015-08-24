//
//  HXTriggerManager.m
//  NeiooPlayground
//
//  Created by hsujahhu on 2015/7/24.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import "HXTriggerManager.h"
#import "HXTriggeredWebViewController.h"
#import "HXDialogView.h"
#import "HXAlertView.h"
#import "SBKBeacon.h"
#import "Config.h"
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioToolbox.h>

@interface HXTriggerManager()<NeiooDelegate>
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
@property HXTriggeredSenario senario;
@end

@implementation HXTriggerManager

+ (HXTriggerManager *)manager
{
    static HXTriggerManager *_manager = nil;
    
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _manager = [[HXTriggerManager alloc] init];
    });
    
    return _manager;
}

- (id)init
{
    self = [super init];
    if (self) {
        [Neioo setUpAppKey:NEIOO_APP_KEY delegate:self withLocationAuthorization:NeiooLocationAuthorizationAlways];
    }
    return self;
}

- (void)startTrigger
{
    [[Neioo shared] enable];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(beacon:)
//                                                 name:SBKBeaconInRangeStatusUpdatedNotification
//                                               object:nil];
}

- (void)stopTrigger
{
    [[Neioo shared] disable];
    [[Neioo shared] clearCriteriaData];
}

- (void)setupSenario:(HXTriggeredSenario)senario
{
    _senario = senario;
}

- (void)beacon:(NSNotification *)notification {
    
    /*Get SBKBeacon object*/
    SBKBeacon *beacon = notification.object;
    
    /*Determine whether 'applicationState' is 'UIApplicationStateBackground' */
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground){
        /*Determine whether the device is in range*/
        if (beacon.inRange) {
            /*Local notification*/
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            NSString * message = @"Enter";
            notification.alertBody = message;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
        else{
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            NSString * message = @"Leave";
            notification.alertBody = message;
            [[UIApplication sharedApplication] scheduleLocalNotification:notification];
        }
    }
}

#pragma mark - neiooDelegate

-(void)campaignTriggered:(NeiooCampaign *)campaign beacon:(NeiooBeacon *)beacon
{
    //Don't show triggered campaign in shake senario
    ////////////////////////////////////////////////
    
    if (_senario == HXTriggeredSenarioShake)return;
    
    //Don't show triggered campaign in target marketing senario
    ////////////////////////////////////////////////
    
    if (_senario == HXTriggeredSenarioTarget) {
        if (!campaign.criterias) return;
        if (!campaign.criterias.count) return;
    }
    
    if ([self.delegate respondsToSelector:@selector(campaignTriggered:beacon:)]) {
        [self.delegate campaignTriggered:campaign beacon:beacon];
    }
    for (NeiooAction *action in campaign.actions){
        NSLog(@"Campaign triggered by SDK \n %@",[action.actionDetail description]);
        
        [self triggerSound];
        [self triggerAction:action];
    }
    
}

- (void)inShakeRangeWithCampaign:(NeiooCampaign *)campaign
{
    NSLog(@"in shake range...");
    if ([self.delegate respondsToSelector:@selector(inShakeRangeWithCampaign:)]) {
        [self.delegate inShakeRangeWithCampaign:campaign];
    }
}

- (void)outOfShakeRangeWithCampaign:(NeiooCampaign *)campaign
{
    NSLog(@"out of shake range...");
    if ([self.delegate respondsToSelector:@selector(outOfShakeRangeWithCampaign:)]) {
        [self.delegate outOfShakeRangeWithCampaign:campaign];
    }
}

- (void)neioo:(Neioo *)neioo didEnterSpace:(NeiooSpace *)space
{
    NSLog(@"Enter Space");
    if ([self.delegate respondsToSelector:@selector(neioo:didEnterSpace:)]) {
        [self.delegate neioo:neioo didEnterSpace:space];
    }
}

- (void)neioo:(Neioo *)neioo didLeaveSpace:(NeiooSpace *)space
{
    NSLog(@"Leave Space");
    if ([self.delegate respondsToSelector:@selector(neioo:didLeaveSpace:)]) {
        [self.delegate neioo:neioo didLeaveSpace:space];
    }
}

#pragma mark - Helper

- (void)shake
{
    NSArray *campaigns = [[Neioo shared]getShakeCampaigns];
    
    for (NeiooCampaign *campaign in campaigns){
        for (NeiooAction *action in campaign.actions){
            NSLog(@"Shake campaign triggered by SDK \n %@",[action.actionDetail description]);
            
            [self shakeTriggerSound];
            [self triggerAction:action];
        }
    }
}

- (void)triggerAction:(NeiooAction *)action
{
    if ([action.type isEqualToString:@"show_image"])
    {
        NSArray *urls;
        if ([action.actionDetail[@"url"] isKindOfClass:[NSString class]]) {
            urls = @[action.actionDetail[@"url"]];
        }else{
            urls = action.actionDetail[@"url"];
        }
        
        NSInteger randomInt = (_senario == HXTriggeredSenarioShake) ? arc4random() % urls.count : 0;
        
        HXImageAlignH alignH = HXImageAlignHCenter;
        if ([action.actionDetail[@"align"] isEqualToString:@"left"]) alignH = HXImageAlignHLeft;
        else if ([action.actionDetail[@"align"] isEqualToString:@"right"]) alignH = HXImageAlignHRight;
        
        HXImageAlignV alignV = HXImageAlignVCenter;
        if ([action.actionDetail[@"v_align"] isEqualToString:@"top"]) alignV = HXImageAlignVTop;
        else if ([action.actionDetail[@"v_align"] isEqualToString:@"bottom"]) alignV = HXImageAlignVBottom;
        
        HXDialogView *dialog = [[HXDialogView alloc]initImageDialogWithUrl:urls[randomInt]
                                                             verticalAlign:alignV
                                                           horizontalAlign:alignH
                                                                    scaleW:[action.actionDetail[@"width"] floatValue]
                                                                    scaleH:[action.actionDetail[@"height"] floatValue]];
        [dialog showWithOpacityAnimation];
    }
    else if ([action.type isEqualToString:@"show_video"])
    {
        if (!self.delegate) return;
            
        UIViewController *currentVc = (UIViewController *)self.delegate;
        self.moviePlayer = [[MPMoviePlayerController alloc] initWithContentURL:[NSURL URLWithString:action.actionDetail[@"url"]]];
        self.moviePlayer.scalingMode = MPMovieScalingModeAspectFit;
        [self.moviePlayer prepareToPlay];
        [self.moviePlayer.view setFrame: currentVc.view.bounds];
        [currentVc.view addSubview: self.moviePlayer.view];
        [self.moviePlayer setFullscreen:YES animated:YES];
        [self.moviePlayer play];
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(playerViewDidExitFullScreen)
                                                     name:MPMoviePlayerWillExitFullscreenNotification
                                                   object:self.moviePlayer];
    }
    else if ([action.type isEqualToString:@"show_webview"])
    {
        if (!self.delegate) return;
        
        UIViewController *currentVc = (UIViewController *)self.delegate;
        HXTriggeredWebViewController *vc = [[HXTriggeredWebViewController alloc]initWithWebUrl:action.actionDetail[@"url"]];
        [currentVc presentViewController:vc animated:YES completion:nil];
    }
    else if ([action.type isEqualToString:@"local_push"])
    {
        HXAlertView *alertView = [[HXAlertView alloc]initWithTitle:nil message:action.actionDetail[@"push_text"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [alertView show];
        });
        
        UILocalNotification *notification = [[UILocalNotification alloc] init];
        notification.alertBody = action.actionDetail[@"push_text"];
        notification.soundName = UILocalNotificationDefaultSoundName;
        notification.fireDate = [NSDate date];
        [[UIApplication sharedApplication] scheduleLocalNotification:notification];
    }
}

- (void)triggerSound
{
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
    NSString *path = [[NSBundle mainBundle] pathForResource:@"ui_lbatlow" ofType:@"wav"];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    // play
    AudioServicesPlaySystemSound(soundID);
}

- (void)shakeTriggerSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"pop" ofType:@"mp3"];
    SystemSoundID soundID;
    NSURL *filePath = [NSURL fileURLWithPath:path isDirectory:NO];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)filePath, &soundID);
    // play
    AudioServicesPlaySystemSound(soundID);
}

#pragma mark - MediaPlayer help

- (void)playerViewDidExitFullScreen {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:MPMoviePlayerWillExitFullscreenNotification
                                                  object:self.moviePlayer];
    [self.moviePlayer stop];
    [self.moviePlayer.view removeFromSuperview];
    self.moviePlayer = nil;
}


@end
