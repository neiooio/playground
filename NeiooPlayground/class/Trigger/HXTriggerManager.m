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

@interface HXTriggerManager()
@property (strong, nonatomic) MPMoviePlayerController *moviePlayer;
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
        
    }
    return self;
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

- (void)triggerCampaign:(NeiooCampaign *)campaign
{
    for (NeiooAction *action in campaign.actions){
        NSLog(@"Campaign triggered by SDK \n %@",[action.actionDetail description]);
        
        [self triggerSound];
        [self triggerAction:action];
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
        
        NSInteger randomInt = arc4random() % urls.count;
        
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
