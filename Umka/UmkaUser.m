//
//  UmkaUser.m
//  Umka
//
//  Created by Igor Zalisky on 12/14/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#define K_APP_MODE_TYPE_KEY @"K_APP_MODE_TYPE_KEY"
#define K_USER_ACCESS_TOKEN @"K_USER_ACCESS_TOKEN"

#define K_USER_NAME_KEY @"K_USER_NAME_KEY"
#define K_USER_FIRST_NAME_KEY @"K_USER_FIRST_NAME_KEY"
#define K_USER_GENDER_KEY @"K_USER_GENDER_KEY"
#define K_USER_PHONE_KEY @"K_USER_PHONE_KEY"
#define K_USER_ID_KEY @"K_USER_ID_KEY"
#define K_MASTER_ID_KEY @"K_MASTER_ID_KEY"
#define K_USER_UID_KEY @"K_USER_UID_KEY"
#define K_USER_PROFILE_KEY @"K_USER_PROFILE_KEY"
#define K_USER_AVATAR_KEY @"K_USER_AVATAR_KEY"
#define K_USER_EMAIL_KEY @"K_USER_EMAIL_KEY"
#define K_USER_LOCATION_KEY @"K_USER_LOCATION_KEY"
#define K_USER_ABOUT_KEY @"K_USER_ABOUT_KEY"

#import "UmkaUser.h"
#import "Constants.h"

@implementation UmkaUser

+(BOOL)isUser{
    return [[self appMode] isEqualToString:@"user"];
}



+ (void)savePhone:(NSString*)phone
{
    [[NSUserDefaults standardUserDefaults] setObject:phone forKey:K_USER_PHONE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)phone
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:K_USER_PHONE_KEY];
}

+ (void)saveAppMode:(NSString*)mode
{
    [[NSUserDefaults standardUserDefaults] setObject:mode forKey:K_APP_MODE_TYPE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)appMode
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:K_APP_MODE_TYPE_KEY];
}

+ (void)saveAccessToken:(NSString*)accessToken
{
    [[NSUserDefaults standardUserDefaults] setObject:accessToken forKey:K_USER_ACCESS_TOKEN];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)accessToken
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:K_USER_ACCESS_TOKEN];
}

+ (void)saveUserID:(NSInteger)userID
{
    [[NSUserDefaults standardUserDefaults] setInteger:userID forKey:K_USER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)userID
{
     return [[NSUserDefaults standardUserDefaults] integerForKey:K_USER_ID_KEY];
}

+ (void)saveMasterID:(NSInteger)masterID
{
    [[NSUserDefaults standardUserDefaults] setInteger:masterID forKey:K_MASTER_ID_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)masterID{
    return [[NSUserDefaults standardUserDefaults] integerForKey:K_MASTER_ID_KEY];
}


+ (void)saveUserProfile:(NSInteger)profile
{
    [[NSUserDefaults standardUserDefaults] setInteger:profile forKey:K_USER_PROFILE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)profile
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:K_USER_PROFILE_KEY];
}

+ (void)saveUserLocation:(NSDictionary*)userLocation
{
    [[NSUserDefaults standardUserDefaults] setObject:userLocation forKey:K_USER_LOCATION_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)latitude
{
    NSDictionary *location = [[NSUserDefaults standardUserDefaults] objectForKey:K_USER_LOCATION_KEY];
    return location[@"lat"];
}

+ (NSString*)longitude
{
    NSDictionary *location = [[NSUserDefaults standardUserDefaults] objectForKey:K_USER_LOCATION_KEY];
    return location[@"lon"];
}

+ (NSString*)city
{
    NSDictionary *location = [[NSUserDefaults standardUserDefaults] objectForKey:K_USER_LOCATION_KEY];
    NSString *cityName = location[@"address"];
    return (cityName)?cityName:NSLocalizedString(@"Город не определен",@"");
}


+(NSString*)fireToken{
    NSString *ft =[[NSUserDefaults standardUserDefaults] objectForKey:K_FIRE_TOKEN_KEY];
    if (!ft) ft = @"FIRETOKEN";
    return ft;
}

@end
