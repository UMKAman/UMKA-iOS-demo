//
//  ApiManager.h
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"
@interface ApiManager : NSObject
- (void)getCategoriesCompletition:(void (^)(NSArray*, NSError *))completitionBlock;
- (void)getAllMastersCompletition:(void (^)(id response, NSError *error))completitionBlock;
- (void)getMastersList:(NSNumber*)item_id completition:(void (^)(id object, NSError *error))completitionBlock;

#pragma Authorization
- (void)checkPhone:(NSDictionary*)params completition:(void (^)(NSDictionary*object, NSError * error))completitionBlock;
- (void)registration:(NSDictionary*)params completition:(void (^)(NSDictionary*object, NSError * error))completitionBlock;
- (void)remindPassword:(NSDictionary*)params completition:(void (^)(NSDictionary*object, NSError * error))completitionBlock;
- (void)resetPassword:(NSDictionary*)params completition:(void (^)(NSDictionary*object, NSError * error))completitionBlock;
- (void)sendPhone:(NSDictionary*)params completition:(void (^)(NSDictionary*, NSError *))completitionBlock;
- (void)sendPhonePIN:(NSDictionary*)params completition:(void (^)(NSDictionary*, NSError *))completitionBlock;
- (void)getAvailibleTimesForDay:(NSDictionary*)params completition:(void (^)(NSArray*, NSError *))completitionBlock;
- (void)uploadImage:(UIImage*)image userID:(NSNumber*)userID completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)viewProfile:(NSString*)profile completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)viewMasterProfile:(NSString*)profile completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)updateUser:(NSNumber*)userID params:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)sendMessage:(NSDictionary*)params image:(UIImage*)image completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)addUserToBlackList:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)removeUserFromBlackList:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;

- (void)removeCategory:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;

#pragma mark - Dialogs
- (void)getDialogsCompletition:(void (^)(NSArray*, NSError *))completitionBlock;
- (void)getMessages:(NSNumber*)chatID completition:(void (^)(id object, NSError *error))completitionBlock;
- (void)sendMessage:(NSDictionary*)params image:(UIImage*)image completition:(void (^)(id object, NSError *error))completitionBlock;

#pragma mark - Favorites

- (void)getFavorites:(NSString*)user_id completition:(void (^)(NSArray*, NSError *))completitionBlock;
- (void)addFavorite:(NSString*)user_id master_id:(NSNumber*)master_id completition:(void (^)(NSArray*, NSError *))completitionBlock;
- (void)delFavorite:(NSString*)user_id master_id:(NSNumber*)master_id completition:(void (^)(NSArray*, NSError *))completitionBlock;

#pragma mark - ORDERS
- (void)getOrders:(NSDictionary*)params completition:(void (^)(NSArray*, NSError *))completitionBlock;
- (void)createOrder:(NSDictionary*)params completition:(void (^)(NSArray*, NSError *))completitionBlock;

#pragma mark - Master Methods
- (void)createMasterCompletition:(void (^)(id response, NSError *error))completitionBlock;
- (void)updateMaster:(NSNumber*)userID params:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)addSpecialization:(NSNumber*)specID forMaster:(NSInteger)master_id completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)delSpecialization:(NSNumber*)specID forMaster:(NSInteger)master_id completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)addService:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)delService:(NSNumber*)service_id completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)addPortfolio:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)updatePortfolio:(NSDictionary*)params item:(NSNumber*)item_id completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)delPortfolio:(NSNumber*)portfolio_id completition:(void (^)(id response, NSError *error))completitionBlock;


#pragma mark - Images
- (void)getImagesForPortfolio:(NSNumber*)portfolio completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)uploadImage:(UIImage*)image forPortfolio:(NSNumber*)portfolio completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)delImage:(NSNumber*)image_id completition:(void (^)(id response, NSError *error))completitionBlock;

#pragma mark - Chats
- (void)createChat:(NSNumber*)userID completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)getAllChatsCompletition:(void (^)(id response, NSError *error))completitionBlock;
- (void)getChatByID:(NSNumber*)chatID  completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)getChatWithMaster:(NSNumber*)masterID completition:(void (^)(id response, NSError *error))completitionBlock;

#pragma mark - Work days
- (void)createWorkday:(NSString*)date completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)deleteWorkday:(NSNumber*)workday_id completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)getAllWorkdaysCompletition:(void (^)(id response, NSError *error))completitionBlock;
- (void)getWorkDay:(NSNumber*)workday_id completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)addWorkhour:(NSNumber*)workhour_id toWorkDay:(NSNumber*)workday_id completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)updateWorkday:(NSNumber*)workday_id params:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;

#pragma mark - Work hours
- (void)createWorkhour:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)deleteWorkhour:(NSNumber*)workhour_id completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)getAllWorkhoursCompletition:(void (^)(id response, NSError *error))completitionBlock;
- (void)getWorkHour:(NSNumber*)workhour_id completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)updateWorkhour:(NSNumber*)workhour_id params:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;

#pragma mark - Reviews

- (void)getReviews:(NSNumber*)user_id completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)sendReview:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;
- (void)updateReview:(NSDictionary*)params reviewID:(NSString*)reviewID completition:(void (^)(id response, NSError *error))completitionBlock;

#pragma mark - Search
- (void)search:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;

- (void)payments:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock;
@end
