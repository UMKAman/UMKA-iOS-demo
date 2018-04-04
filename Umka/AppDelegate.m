//
//  AppDelegate.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "AppDelegate.h"
#import "AuthorizationController.h"
#import "Constants.h"
#import "UmkaUser.h"
#import "CalendarCell.h"
@import GoogleMaps;
@import Firebase;
#import "UmkaCallendar.h"
#import "LeftMenuController.h"
#import "UserMessagesController.h"

#if USE_GOOGLE_MAPS_SERVICE
#import <GoogleMaps/GoogleMaps.h>
#endif

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@import UserNotifications;
#endif

@import Firebase;
@import FirebaseInstanceID;
@import FirebaseMessaging;

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
@interface AppDelegate ()<UNUserNotificationCenterDelegate,FIRMessagingDelegate>
@end
#endif

#ifndef NSFoundationVersionNumber_iOS_9_x_Max
#define NSFoundationVersionNumber_iOS_9_x_Max 1299
#endif

@interface AppDelegate ()
@property (nonatomic, strong) UIViewController *preloadView;
@property (nonatomic, strong) UIViewController *authController;
@property (nonatomic, strong) UIViewController *leftMenu;
@end

@implementation AppDelegate

NSString *const kGCMMessageIDKey = @"494924372454";//@"131798438791";
+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)([[UIApplication sharedApplication] delegate]);
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    [GMSServices provideAPIKey:K_GOOGLE_MAPS_API_KEY];
    
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
        UIUserNotificationType allNotificationTypes =
        (UIUserNotificationTypeSound | UIUserNotificationTypeAlert | UIUserNotificationTypeBadge);
        UIUserNotificationSettings *settings =
        [UIUserNotificationSettings settingsForTypes:allNotificationTypes categories:nil];
        [[UIApplication sharedApplication] registerUserNotificationSettings:settings];
    } else {
        // iOS 10 or later
#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0
        UNAuthorizationOptions authOptions =
        UNAuthorizationOptionAlert
        | UNAuthorizationOptionSound
        | UNAuthorizationOptionBadge;
        [[UNUserNotificationCenter currentNotificationCenter] requestAuthorizationWithOptions:authOptions completionHandler:^(BOOL granted, NSError * _Nullable error) {
        }];
        
        // For iOS 10 display notification (sent via APNS)
        [UNUserNotificationCenter currentNotificationCenter].delegate = self;
        // For iOS 10 data message (sent via FCM)
        [FIRMessaging messaging].delegate = self;
#endif
    }
    
    [[UIApplication sharedApplication] registerForRemoteNotifications];
    [FIRApp configure];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tokenRefreshNotification:)
                                                 name:kFIRInstanceIDTokenRefreshNotification object:nil];
    
    NSString *accessToken = [UmkaUser accessToken];
    if (accessToken && accessToken.length>0)[self showMainMenu];
    else [self showAuth];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[FIRMessaging messaging] shouldEstablishDirectChannel];
    NSLog(@"Disconnected from FCM");
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self connectToFcm];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)showAuth
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.authController = [storyboard instantiateViewControllerWithIdentifier:@"AuthorizationController"];
    [self.window setRootViewController:self.authController];

}


- (void)showPreloadView
{
    self.preloadView = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"PreloadView"];
    [self.window addSubview:self.preloadView.view];
    
}

- (void)hidePreloadView
{
    [self.preloadView.view removeFromSuperview];
}

- (void)showMainMenu
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    self.leftMenu = [storyboard instantiateViewControllerWithIdentifier:@"LeftMenuController"];
    [self.window setRootViewController:self.leftMenu];
}


#pragma  mark PUSH

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    NSLog(@"%@", userInfo);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    NSLog(@"%@", userInfo);
    
    completionHandler(UIBackgroundFetchResultNewData);
}

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
       willPresentNotification:(UNNotification *)notification
         withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
    NSDictionary *userInfo = notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    
    NSLog(@"%@", userInfo);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"K_RELOAD_CHAT_NAME" object:nil];
    completionHandler(UNNotificationPresentationOptionAlert);
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
    NSDictionary *userInfo = response.notification.request.content.userInfo;
    if (userInfo[kGCMMessageIDKey]) {
        NSLog(@"Message ID: %@", userInfo[kGCMMessageIDKey]);
    }
    [[kMainViewController leftViewController] selectRootController];
    UITabBarController *tabbarController = (UITabBarController*)[kNavigationController topViewController];
    [tabbarController setSelectedIndex:1];
    UserMessagesController *dialogs = (UserMessagesController*)[(UINavigationController*)tabbarController.viewControllers[1] topViewController];
    [dialogs openChatWithChatID:userInfo[@"chat"]];
    
    NSLog(@"%@", userInfo);
    completionHandler();
}
#endif

#if defined(__IPHONE_10_0) && __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_10_0

- (void)applicationReceivedRemoteMessage:(FIRMessagingRemoteMessage *)remoteMessage {
    NSLog(@"%@", remoteMessage.appData);
}
#endif

- (void)tokenRefreshNotification:(NSNotification *)notification {
    NSString *refreshedToken = [[FIRInstanceID instanceID] token];
    NSLog(@"InstanceID token: %@", refreshedToken);
    [[NSUserDefaults standardUserDefaults] setObject:refreshedToken forKey:K_FIRE_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self connectToFcm];
}

- (void)connectToFcm {
    if (![[FIRInstanceID instanceID] token]) {
        return;
    }
    [[FIRMessaging messaging] shouldEstablishDirectChannel];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"Unable to register for remote notifications: %@", error);
}
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
     [FIRMessaging messaging].APNSToken = deviceToken;
    
    NSString *fcmToken = [FIRMessaging messaging].FCMToken;
    NSLog(@"FCM registration token: %@", fcmToken);
    [[NSUserDefaults standardUserDefaults] setObject:fcmToken forKey:K_FIRE_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)messaging:(FIRMessaging *)messaging didRefreshRegistrationToken:(NSString *)fcmToken{
    NSLog(@"FCM registration token: %@", fcmToken);
    [[NSUserDefaults standardUserDefaults] setObject:fcmToken forKey:K_FIRE_TOKEN_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}




@end
