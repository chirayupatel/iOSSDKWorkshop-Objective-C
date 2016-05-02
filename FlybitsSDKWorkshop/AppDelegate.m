//
//  AppDelegate.m
//  FlybitsSDKWorkshop
//
//  Created by Terry Latanville on 2016-04-27.
//  Copyright © 2016 Flybits Inc. All rights reserved.
//

@import FlybitsSDK;

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

#pragma mark - Constants

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.

    // Tutorial Section 0.0 (API Key)
    [[[Session sharedInstance] configuration] setAPIKey:@"<#API Key#>"];

    // Tutorial Section 7.1 (Push Notifications)
    UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
    
    [application registerUserNotificationSettings:settings];
    [application registerForRemoteNotifications];

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

// Tutorial Section 7.2 (Push Notifications)
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    NSDictionary *userInfo = [NSDictionary dictionaryWithObject:deviceToken forKey:@"com.flybits.push.token"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"com.flybits.push.receivedToken" object:nil userInfo:userInfo];
}

// Tutorial Section 7.5 (Push Notifications)
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler
{
    BOOL handled = [[PushManager sharedManager] notificationReceived:userInfo fetchCompletionHandler:^(UIBackgroundFetchResult result) {
        completionHandler(result);
    }];
    
    if(!handled) {
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

@end
