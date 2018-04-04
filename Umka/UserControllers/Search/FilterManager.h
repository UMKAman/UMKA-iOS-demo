//
//  FilterManager.h
//  Umka
//
//  Created by Igor Zalisky on 12/7/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface FilterManager : NSObject

+ (void)saveCategories:(NSArray*)categories;
+ (NSArray*)allCategories;

+ (void)saveGender:(NSInteger)gender;
+ (NSInteger)gender;

+ (void)saveSortBy:(NSInteger)sortBy;
+ (NSInteger)sortBy;

+ (void)saveSpec:(NSDictionary*)spec;
+ (NSDictionary*)spec;

+ (void)saveCity:(NSDictionary*)city;
+ (NSDictionary*)city;

+ (void)saveToHomeOption:(BOOL)toHome;
+ (BOOL)toHome;

+ (void)saveInMasterOption:(BOOL)InMaster;
+ (BOOL)InMaster;

+ (void)saveOnlineOption:(BOOL)online;
+ (BOOL)online;

+ (void)saveWithReviewsOption:(BOOL)withReviews;
+ (BOOL)withReviews;

+ (void)savePrice:(NSString*)price;
+ (NSString*)price;

+ (void)resetOptions;

+ (NSInteger)budgesNumber;

@end
