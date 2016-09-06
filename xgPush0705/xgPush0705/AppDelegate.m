//
//  AppDelegate.m
//  xgPush0705
//
//  Created by 李根 on 16/7/5.
//  Copyright © 2016年 ligen. All rights reserved.
//

#import "AppDelegate.h"
#import "XGPush.h"
#import "XGSetting.h"

#define _IPHONE_ 80000

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)registerPushForIOS8 {
    //  Types
    UIUserNotificationType types =
        UIUserNotificationTypeBadge |
        UIUserNotificationTypeSound |
        UIUserNotificationTypeAlert;
    
    //  Actions
    UIMutableUserNotificationAction *accessAction = [[UIMutableUserNotificationAction alloc] init];
    
    accessAction.identifier = @"ACCEPT_IDENTIFIER";
    accessAction.title = @"Accept";
    
    accessAction.activationMode = UIUserNotificationActivationModeForeground;
    accessAction.destructive = NO;
    accessAction.authenticationRequired = NO;
    
    //  Categories
    UIMutableUserNotificationCategory *inviteCategory = [[UIMutableUserNotificationCategory alloc] init];
    inviteCategory.identifier = @"INVITE_CATEGORY";
    [inviteCategory setActions:@[accessAction] forContext:UIUserNotificationActionContextDefault];
    [inviteCategory setActions:@[accessAction] forContext:UIUserNotificationActionContextMinimal];
    
    NSSet *categories = [NSSet setWithObjects:inviteCategory, nil];
    
    UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:categories];
    [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    
    
    
    
}

- (void)registerPush {
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:(UIRemoteNotificationTypeAlert | UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound)];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    [XGPush startApp:2200207568 appKey:@"IZV6I85V41TT"];
    [XGPush handleLaunching:launchOptions];
    
    float sysVer = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (sysVer < 8) {
        [self registerPush];
    }
    else {
        [self registerPushForIOS8];
    }
    
    
    return YES;
}

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= _IPHONE80_
//  注册UserNotification成功的回调
- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    
}

//  按钮点击事件回调
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void (^)())completionHandler {
    if ([identifier isEqualToString:@"ACCEPT_IDENTIFIER"]) {
        NSLog(@"ACCEPT_IDENTIFIER is clicked");
    }
    
    completionHandler();
}

#endif

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    void (^successBlock)(void) = ^(void) {
        //  成功之后的处理
        NSLog(@"[XGPush Push] register successBlock");
    };
    
    void (^errorBlock)(void) = ^(void) {
        //  失败之后的处理
        NSLog(@"[XGPush Push] register errorBlock");
    };
    
    //  注册设备
    NSString *deviceTokenStr = [XGPush registerDevice:deviceToken successCallback:successBlock errorCallback:errorBlock];
    
    //  打印偶去的deviceToken的字符串
    NSLog(@"XGPush deviceTokenStr is %@", deviceTokenStr);
}

//  如果deviceToken获取不到会进入此事件
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
    NSString *str = [NSString stringWithFormat:@"Error: %@", error];
    NSLog(@"XGPush: %@", str);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    //  推送反馈(app运行时)
    [XGPush handleReceiveNotification:userInfo];
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

@end
