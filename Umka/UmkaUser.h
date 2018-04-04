//
//  UmkaUser.h
//  Umka
//
//  Created by Igor Zalisky on 12/14/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UmkaUser : NSObject
+(BOOL)isUser;

+ (void)savePhone:(NSString*)phone;
+ (NSString*)phone;

+ (void)saveAppMode:(NSString*)mode;
+ (NSString*)appMode;

+ (void)saveAccessToken:(NSString*)accessToken;
+ (NSString*)accessToken;

+ (void)saveMasterID:(NSInteger)masterID;
+ (NSInteger)masterID;

+ (void)saveUserID:(NSInteger)userID;
+ (NSInteger)userID;

+ (void)saveUserProfile:(NSInteger)profile;
+ (NSInteger)profile;

+ (void)saveUserLocation:(NSDictionary*)userLocation;
+ (NSString*)latitude;
+ (NSString*)longitude;
+ (NSString*)city;

+(NSString*)fireToken;

@end
