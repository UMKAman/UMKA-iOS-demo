//
//  FilterManager.m
//  Umka
//
//  Created by Igor Zalisky on 12/7/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "FilterManager.h"
#import "Constants.h"

#define K_ALL_CATEGORIES_KEY @"K_ALL_CATEGORIES_KEY"
#define K_FILTER_CITY_KEY @"K_FILTER_CITY_KEY"
#define K_FILTER_GENDER_KEY @"K_FILTER_GENDER_KEY"
#define K_FILTER_SPEC_KEY @"K_FILTER_SPEC_KEY"
#define K_FILTER_SORT_BY_KEY @"K_FILTER_SORT_BY_KEY"

#define K_FILTER_TO_HOME_KEY @"K_FILTER_TO_HOME_KEY"
#define K_FILTER_IN_MASTER_KEY @"K_FILTER_IN_MASTER_KEY"
#define K_FILTER_ONLINE_KEY @"K_FILTER_ONLINE_KEY"
#define K_FILTER_WITH_REVIEWS_KEY @"K_FILTER_WITH_REVIEWS_KEY"
#define K_FILTER_PRICE_KEY @"K_FILTER_PRICE_KEY"

@implementation FilterManager


+ (void)saveCategories:(NSArray*)categories
{
    [[NSUserDefaults standardUserDefaults] setObject:categories forKey:K_ALL_CATEGORIES_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSArray*)allCategories
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:K_ALL_CATEGORIES_KEY];
}



+ (void)saveGender:(NSInteger)gender
{
    [[NSUserDefaults standardUserDefaults] setInteger:gender forKey:K_FILTER_GENDER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSInteger)gender
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:K_FILTER_GENDER_KEY];
}



+ (void)saveSortBy:(NSInteger)sortBy
{
    [[NSUserDefaults standardUserDefaults] setInteger:sortBy forKey:K_FILTER_SORT_BY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSInteger)sortBy
{
    return [[NSUserDefaults standardUserDefaults] integerForKey:K_FILTER_SORT_BY_KEY];
}


+ (void)saveSpec:(NSDictionary*)spec
{
    [[NSUserDefaults standardUserDefaults] setObject:spec forKey:K_FILTER_SPEC_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSDictionary*)spec
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:K_FILTER_SPEC_KEY];
}



+ (void)saveCity:(NSDictionary*)city
{
    [[NSUserDefaults standardUserDefaults] setObject:city forKey:K_FILTER_CITY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


+ (NSDictionary*)city
{
    NSDictionary *p = [[NSUserDefaults standardUserDefaults] objectForKey:K_FILTER_CITY_KEY];
    if (!p) p = @{};
    return  p;
}

+ (void)saveToHomeOption:(BOOL)toHome
{
    [[NSUserDefaults standardUserDefaults] setBool:toHome forKey:K_FILTER_TO_HOME_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)toHome
{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:K_FILTER_TO_HOME_KEY];
}

+ (void)saveInMasterOption:(BOOL)InMaster
{
    [[NSUserDefaults standardUserDefaults] setBool:InMaster forKey:K_FILTER_IN_MASTER_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)InMaster{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:K_FILTER_IN_MASTER_KEY];
}

+ (void)saveOnlineOption:(BOOL)online
{
    [[NSUserDefaults standardUserDefaults] setBool:online forKey:K_FILTER_ONLINE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)online{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:K_FILTER_ONLINE_KEY];
}

+ (void)saveWithReviewsOption:(BOOL)withReviews
{
    [[NSUserDefaults standardUserDefaults] setBool:withReviews forKey:K_FILTER_WITH_REVIEWS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (BOOL)withReviews{
    return  [[NSUserDefaults standardUserDefaults] boolForKey:K_FILTER_WITH_REVIEWS_KEY];
}

+ (void)savePrice:(NSString*)price
{
    [[NSUserDefaults standardUserDefaults] setObject:price forKey:K_FILTER_PRICE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSString*)price
{
    NSString *p = [[NSUserDefaults standardUserDefaults] objectForKey:K_FILTER_PRICE_KEY];
    if (!p) p = K_FILTER_MAX_PRICE;
    return  p;
}

+ (void)resetOptions
{
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:K_FILTER_GENDER_KEY];
    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:K_FILTER_SORT_BY_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:K_FILTER_SPEC_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:K_FILTER_CITY_KEY];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:K_FILTER_TO_HOME_KEY];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:K_FILTER_IN_MASTER_KEY];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:K_FILTER_ONLINE_KEY];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:K_FILTER_WITH_REVIEWS_KEY];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:K_FILTER_PRICE_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (NSInteger)budgesNumber
{
    NSInteger budges = 0;
    NSArray *badgeKeys = @[K_FILTER_TO_HOME_KEY,K_FILTER_IN_MASTER_KEY,K_FILTER_ONLINE_KEY,K_FILTER_WITH_REVIEWS_KEY];
    for (NSString *key in badgeKeys)
    {
        BOOL nb = [[NSUserDefaults standardUserDefaults] boolForKey:key];
        if (nb==YES)budges = budges+1;
    }
    return budges;
}

@end
