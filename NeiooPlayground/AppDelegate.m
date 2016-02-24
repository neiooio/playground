//
//  AppDelegate.m
//  NeiooPlayground
//
//  Created by hsujahhu on 2015/7/23.
//  Copyright (c) 2015年 Herxun. All rights reserved.
//

#import "AppDelegate.h"
#import "HXMenuViewController.h"
#import "Config.h"
#import "Neioo.h"
#import "HXTriggerManager.h"
#import "UIColor+CustomColor.h"

@interface AppDelegate ()
@property(strong, nonatomic)HXMenuViewController * menuVC;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    // For splash page
    sleep(2);
    
    // For local push
    
    if (iOS8) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeBadge|UIUserNotificationTypeSound|UIUserNotificationTypeAlert categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    }else{
        [application registerForRemoteNotificationTypes:UIRemoteNotificationTypeAlert];
    }
    
    // Important!!!!!!!!
    // setup Neioo
    [Neioo setUpAppKey:NEIOO_APP_KEY];
    
    // Navi appearence
    [self customizeAppearance];
    
    // init menu vc
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.menuVC = [[HXMenuViewController alloc]init];
    
    UINavigationController * nav = [[UINavigationController alloc]initWithRootViewController:self.menuVC];
    self.window.rootViewController = nav;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    
    // launch app from notification
    if (launchOptions) {
        UILocalNotification *notification = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
        
        if (notification) {
            [HXTriggerManager manager].campaignFromNotification = [Neioo getNotificationCampaign:notification];
            if ([HXTriggerManager manager].campaignFromNotification) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"openLocalPush" object:nil];
            }
        }
        
    }
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    if (notification) {
        [HXTriggerManager manager].campaignFromNotification = [Neioo getNotificationCampaign:notification];
        if ([HXTriggerManager manager].campaignFromNotification) {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"openLocalPush" object:nil];
        }
    }
}

#pragma mark - custom appearence

-(void)customizeAppearance
{
    [[UINavigationBar appearance] setBarTintColor:[UIColor color6]];
    [[UINavigationBar appearance] setTintColor:[UIColor color10]];
    
}

@end
