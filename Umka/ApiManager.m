//
//  ApiManager.m
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//


#define K_API_CATEGORY_LIST_URL @"specialization"
#define K_API_MASTERS_LIST_URL @"specialization/%@/inMaster"
#define K_API_AUTH_URL @"auth"
#define K_API_DAY_TIMES_URL @"profile-schedule-item/view-day"
#define K_API_ADD_TIMES_URL @"profile-schedule-item/create"
#define K_API_UPLOAD_AVATAR_URL @"user"
#define K_API_VIEW_PROFILE_URL @"user"
#define K_API_VIEW_MASTER_PROFILE_URL @"master"
#define K_API_MESSAGES_LIST_URL @"chat-item/messages?page="
#define K_API_CHAT_SEND_URL @"chat-item/create"
#define K_API_CHAT_LOCK_URL @"chat-block/create"
#define K_API_CHAT_UNLOCK_URL @"chat-block/delete"
#define K_API_ADD_NEW_CATEGORY @"rel-profile-section/create"
#define K_API_REMOVE_CATEGORY @"rel-profile-section/delete?id="
#define K_API_ADD_PRICE_URL @"profile-price-item/create"
#define K_API_REMOVE_PRICE_URL @"profile-price-items/"
#define K_API_ADD_PORTFOLIO_URL @"profile-portfolio-item/create"
#define K_API_REMOVE_PORTFOLIO_URL @"profile-portfolio-items/"
#define K_API_FAVORITE_URL @"user/%@/favorite"

#define K_API_DIALOGS @"chat"
#define K_API_MESSAGES @"chat/"
#define K_API_SEND_MESSAGE @"chatmessage"




@implementation ApiManager

- (void)search:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загружаю…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@search",K_API_DOMAIN_URL];
    [self sendGETRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        completitionBlock (object,error);
    }];
}

#pragma mark - Reviews

- (void)getReviews:(NSNumber*)user_id completition:(void (^)(id response, NSError *error))completitionBlock{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загружаю…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@review",K_API_DOMAIN_URL];
    NSDictionary *params = @{@"where":@{@"master":user_id}};
    [self sendGETRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        completitionBlock (object,error);
    }];
}

- (void)sendReview:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@review",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

- (void)updateReview:(NSDictionary*)params reviewID:(NSString*)reviewID completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@review/%@",K_API_DOMAIN_URL,reviewID];
    [self sendPUTRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

#pragma marks - payments

- (void)payments:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@payments",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

#pragma mark - Work days

- (void)createWorkday:(NSString*)date completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@workday",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:@{@"master":[NSNumber numberWithInteger:[UmkaUser masterID]],@"date":date} headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

- (void)deleteWorkday:(NSNumber*)workday_id completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@workday/%@",K_API_DOMAIN_URL,workday_id];
    [self sendDELETERequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

- (void)getAllWorkdaysCompletition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@workday",K_API_DOMAIN_URL];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

- (void)getWorkDay:(NSNumber*)workday_id completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@workday/%@",K_API_DOMAIN_URL,workday_id];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

- (void)addWorkhour:(NSNumber*)workhour_id toWorkDay:(NSNumber*)workday_id completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@workday/%@/workhours/%@",K_API_DOMAIN_URL,workday_id,workhour_id];
    [self sendRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

- (void)updateWorkday:(NSNumber*)workday_id params:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@workday/%@",K_API_DOMAIN_URL,workday_id];
    [self sendPUTRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

#pragma mark - Work hours

- (void)createWorkhour:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@workhour",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

- (void)deleteWorkhour:(NSNumber*)workhour_id completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@workhour/%@",K_API_DOMAIN_URL,workhour_id];
    [self sendDELETERequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

- (void)getAllWorkhoursCompletition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@workhour",K_API_DOMAIN_URL];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}


- (void)getWorkHour:(NSNumber*)workhour_id completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@workhour/%@",K_API_DOMAIN_URL,workhour_id];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

- (void)updateWorkhour:(NSNumber*)workhour_id params:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@workhour/%@",K_API_DOMAIN_URL,workhour_id];
    [self sendPUTRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

#pragma mark - Chats
- (void)createChat:(NSNumber*)userID completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@chat",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:@{@"user":[NSNumber numberWithInteger:[UmkaUser userID]],@"master":userID} headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}
- (void)getAllChatsCompletition:(void (^)(id response, NSError *error))completitionBlock{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загружаю…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@chat",K_API_DOMAIN_URL];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        completitionBlock (object,error);
    }];
}
- (void)getChatByID:(NSNumber*)chatID  completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@chat/%@",K_API_DOMAIN_URL,chatID];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}
- (void)getChatWithMaster:(NSNumber*)masterID completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@chat?master=%@",K_API_DOMAIN_URL,masterID];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}

#pragma mark -  Favorite 

- (void)getFavorites:(NSString*)user_id completition:(void (^)(NSArray*, NSError *))completitionBlock{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загружаю…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@user/%@/favorite",K_API_DOMAIN_URL,user_id];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        completitionBlock (object,error);
    }];
}

- (void)addFavorite:(NSString*)user_id master_id:(NSNumber*)master_id completition:(void (^)(NSArray*, NSError *))completitionBlock{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загружаю…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@user/%@/favorite/%@",K_API_DOMAIN_URL,user_id,master_id];
    [self sendRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        completitionBlock (object,error);
    }];
}

- (void)delFavorite:(NSString*)user_id master_id:(NSNumber*)master_id completition:(void (^)(NSArray*, NSError *))completitionBlock{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загружаю…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@user/%@/favorite/%@",K_API_DOMAIN_URL,user_id,master_id];
    [self sendDELETERequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        completitionBlock (object,error);
    }];
}

#pragma mark -  Orders

- (void)getOrders:(NSDictionary*)params completition:(void (^)(NSArray*, NSError *))completitionBlock{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загружаю…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@order",K_API_DOMAIN_URL];
    [self sendGETRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        completitionBlock (object,error);
    }];
}

- (void)createOrder:(NSDictionary*)params completition:(void (^)(NSArray*, NSError *))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@order",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object,error);
    }];
}


- (void)getCategoriesCompletition:(void (^)(NSArray*, NSError *))completitionBlock{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загружаю…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *url = [NSString stringWithFormat:@"%@%@",K_API_DOMAIN_URL,K_API_CATEGORY_LIST_URL];
    [self sendGETRequestWithURL:url params:nil headers:nil complition:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        completitionBlock (object,error);
    }];
}

- (void)viewProfile:(NSString*)profile completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",K_API_DOMAIN_URL,K_API_VIEW_PROFILE_URL,profile];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}

- (void)updateProfile:(NSString*)profile params:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",K_API_DOMAIN_URL,K_API_VIEW_PROFILE_URL,profile];
    [self sendPUTRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}


- (void)createMasterCompletition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@master",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}

- (void)addService:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@masterservice",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}

- (void)updatePortfolio:(NSDictionary*)params item:(NSNumber*)item_id completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@masterservice/%@",K_API_DOMAIN_URL,item_id];
    [self sendDELETERequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}

- (void)delService:(NSNumber*)service_id completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@masterservice/%@",K_API_DOMAIN_URL,service_id];
    [self sendDELETERequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}

- (void)getAllMastersCompletition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@master",K_API_DOMAIN_URL];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}

- (void)viewMasterProfile:(NSString*)profile completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",K_API_DOMAIN_URL,K_API_VIEW_MASTER_PROFILE_URL,profile];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}

- (void)addSpecialization:(NSNumber*)specID forMaster:(NSInteger)master_id completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@master/%ld/specializations/%@",K_API_DOMAIN_URL,master_id,specID];
    [self sendRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}

- (void)delSpecialization:(NSNumber*)specID forMaster:(NSInteger)master_id completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@master/%ld/specializations/%@",K_API_DOMAIN_URL,master_id,specID];
    [self sendDELETERequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}

- (void)updateUserProfile:(NSString*)profile params:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",K_API_DOMAIN_URL,K_API_VIEW_PROFILE_URL,profile];
    
    [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        completitionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completitionBlock(nil, nil);
    }];
}

- (void)updateMasterProfile:(NSString*)profile params:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@/%@",K_API_DOMAIN_URL,K_API_VIEW_PROFILE_URL,profile];
    
    [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"%@",responseObject);
        completitionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completitionBlock(nil, nil);
    }];
}


- (void)getMastersList:(NSNumber*)item_id completition:(void (^)(id object, NSError *error))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
     NSString *url = [NSString stringWithFormat:@"%@specialization/%@/inMaster",K_API_DOMAIN_URL,item_id];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock (object, error);
    }];
    
}

#pragma mark - Authorization

- (void)checkPhone:(NSDictionary*)params completition:(void (^)(NSDictionary*object, NSError * error))completitionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@auth/checkPhone",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:params headers:nil complition:^(id object, NSError *error) {
        completitionBlock(object, error);
    }];
}

- (void)registration:(NSDictionary*)params completition:(void (^)(NSDictionary*object, NSError * error))completitionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@auth/registration",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:params headers:nil complition:^(id object, NSError *error) {
        completitionBlock(object, error);
    }];
}

- (void)remindPassword:(NSDictionary*)params completition:(void (^)(NSDictionary*object, NSError * error))completitionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@auth/remindPassword",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:params headers:nil complition:^(id object, NSError *error) {
        completitionBlock(object, error);
    }];
}

- (void)resetPassword:(NSDictionary*)params completition:(void (^)(NSDictionary*object, NSError * error))completitionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@auth/resetPassword",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:params headers:nil complition:^(id object, NSError *error) {
        completitionBlock(object, error);
    }];
}

- (void)sendPhone:(NSDictionary*)params completition:(void (^)(NSDictionary*object, NSError * error))completitionBlock
{
    NSString *url = [NSString stringWithFormat:@"%@%@",K_API_DOMAIN_URL,K_API_AUTH_URL];
    [self sendRequestWithURL:url params:params headers:nil complition:^(id object, NSError *error) {
        completitionBlock(object, error);
    }];
}

- (void)sendPhonePIN:(NSDictionary*)params completition:(void (^)(NSDictionary*, NSError *))completitionBlock
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",K_API_DOMAIN_URL,K_API_AUTH_URL];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completitionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completitionBlock(nil, nil);
    }];
}

- (void)getAvailibleTimesForDay:(NSDictionary*)params completition:(void (^)(NSArray*, NSError *))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authToken forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@%@",K_API_DOMAIN_URL,K_API_DAY_TIMES_URL];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completitionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completitionBlock(nil, nil);
    }];
}

- (void)updateUser:(NSNumber*)userID params:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Обновляю профиль…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
     NSString *url = [NSString stringWithFormat:@"%@%@/%@",K_API_DOMAIN_URL,K_API_VIEW_PROFILE_URL,userID];
    [self sendPUTRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
         [SVProgressHUD dismiss];
        completitionBlock (object,error);
    }];
}

- (void)updateMaster:(NSNumber*)userID params:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Обновляю профиль…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@master/%@",K_API_DOMAIN_URL,userID];
    [self sendPUTRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        completitionBlock (object,error);
    }];
}


- (void)uploadImage:(UIImage*)image userID:(NSNumber*)userID completition:(void (^)(id response, NSError *error))completitionBlock
{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загружаю фотографию…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *uploadUrl = [NSString stringWithFormat:@"%@%@/%@",K_API_DOMAIN_URL,K_API_UPLOAD_AVATAR_URL,userID];
    NSString *boundary = [self generateBoundaryString];
    
    // configure the request
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:uploadUrl]];
    [request setHTTPMethod:@"PUT"];
    
    // set content type
    [request addValue:authToken forHTTPHeaderField:@"Authorization"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    // create body
    
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:nil image:image fieldName:@"avatar"];
    
    NSURLSession *session = [NSURLSession sharedSession];  // use sharedSession or create your own
    
    NSURLSessionTask *task = [session uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
           [SVProgressHUD dismiss];
            if (error) {
                completitionBlock (nil,error);
                return;
            }
            NSError *err = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if (err != nil) {
                completitionBlock (nil,err);
            }
            else {
                completitionBlock (object,error);
            }
        });
    }];
    [task resume];
}

- (NSString *)generateBoundaryString {
    return [NSString stringWithFormat:@"Boundary-%@", [[NSUUID UUID] UUIDString]];
}

- (NSData *)createBodyWithBoundary:(NSString *)boundary
                        parameters:(NSDictionary *)parameters
                             image:(UIImage *)image
                         fieldName:(NSString *)fieldName {
    NSMutableData *httpBody = [NSMutableData data];
    
    // add params (all params are strings)
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(NSString *parameterKey, NSString *parameterValue, BOOL *stop) {
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", parameterKey] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"%@\r\n", parameterValue] dataUsingEncoding:NSUTF8StringEncoding]];
    }];
    
    // add image data
    
    if (image) {
        NSData   *data      = UIImageJPEGRepresentation(image, 1.0);
       // NSString *mimetype  = [self mimeTypeForPath:path];
        
        [httpBody appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"avatar.jpg\"\r\n",fieldName] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [httpBody appendData:data];
        [httpBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    }
    [httpBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    return httpBody;
}


- (void)addUserToBlackList:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authToken forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@%@",K_API_DOMAIN_URL,K_API_CHAT_LOCK_URL];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completitionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completitionBlock(nil, nil);
    }];
}

- (void)removeUserFromBlackList:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authToken forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@%@",K_API_DOMAIN_URL,K_API_CHAT_UNLOCK_URL];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completitionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completitionBlock(nil, nil);
    }];
}

- (void)addNewCategoryForMaster:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authToken forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@%@",K_API_DOMAIN_URL,K_API_ADD_NEW_CATEGORY];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completitionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completitionBlock(nil, nil);
    }];
}

- (void)removeCategory:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authToken forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",K_API_DOMAIN_URL,K_API_REMOVE_CATEGORY,params[@"id"]];
    params = nil;
    [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completitionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completitionBlock(nil, nil);
    }];
}

- (void)addPrice:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authToken forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@%@",K_API_DOMAIN_URL,K_API_ADD_PRICE_URL];
    [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completitionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completitionBlock(nil, nil);
    }];
}


- (void)removePrice:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:authToken forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",K_API_DOMAIN_URL,K_API_REMOVE_PRICE_URL,params[@"id"]];
    params = nil;
    [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        completitionBlock(responseObject, nil);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        completitionBlock(nil, nil);
    }];
}

- (void)addPortfolio:(NSDictionary*)params completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@portfolio",K_API_DOMAIN_URL];
    [self sendRequestWithURL:url params:params headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
    
}

- (void)delPortfolio:(NSNumber*)portfolio_id completition:(void (^)(id response, NSError *error))completitionBlock
{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@portfolio/%@",K_API_DOMAIN_URL,portfolio_id];
    [self sendDELETERequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}

- (void)getImagesForPortfolio:(NSNumber*)portfolio completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@portfolioPic",K_API_DOMAIN_URL];
    [self sendGETRequestWithURL:url params:@{@"where":@{@"portfolio":portfolio}} headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}

- (void)uploadImage:(UIImage*)image forPortfolio:(NSNumber*)portfolio completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@portfoliopic",K_API_DOMAIN_URL];
    [self uploadImageWithURL:url image:image params:@{@"portfolio":portfolio} headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}


- (void)delImage:(NSNumber*)image_id completition:(void (^)(id response, NSError *error))completitionBlock{
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *url = [NSString stringWithFormat:@"%@portfoliopic/%@",K_API_DOMAIN_URL,image_id];
    [self sendDELETERequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        completitionBlock(object,error);
    }];
}

#pragma mark - Dialogs

- (void)getDialogsCompletition:(void (^)(NSArray*, NSError *))completitionBlock{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSLog(@"%@",authToken);
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загружаю…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *url = [NSString stringWithFormat:@"%@%@",K_API_DOMAIN_URL,K_API_DIALOGS];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        completitionBlock (object,error);
    }];
}

- (void)getMessages:(NSNumber*)chatID completition:(void (^)(id object, NSError *error))completitionBlock{
    NSString *authToken = [NSString stringWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSLog(@"%@",authToken);
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Загружаю…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *url = [NSString stringWithFormat:@"%@%@%@",K_API_DOMAIN_URL,K_API_MESSAGES,chatID];
    [self sendGETRequestWithURL:url params:nil headers:@{@"Authorization":authToken} complition:^(id object, NSError *error) {
        [SVProgressHUD dismiss];
        completitionBlock (object,error);
    }];
}

- (void)sendMessage:(NSDictionary*)params image:(UIImage*)image completition:(void (^)(id object, NSError *error))completitionBlock{
    [SVProgressHUD showWithStatus:NSLocalizedString(@"Отправляю…", nil) maskType:SVProgressHUDMaskTypeClear];
    NSString *url = [NSString stringWithFormat:@"%@%@",K_API_DOMAIN_URL,K_API_SEND_MESSAGE];
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
    NSString *boundary = [self generateBoundaryString];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [request setHTTPMethod:@"POST"];
    [request addValue:authToken forHTTPHeaderField:@"Authorization"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [request setValue:contentType forHTTPHeaderField: @"Content-Type"];
    NSData *httpBody = [self createBodyWithBoundary:boundary parameters:params image:image fieldName:@"pic"];
    NSURLSession *session = [NSURLSession sharedSession];  // use sharedSession or create your own
    NSURLSessionTask *task = [session uploadTaskWithRequest:request fromData:httpBody completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completitionBlock (nil,error);
                return;
            }
            NSError *err = nil;
            id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&err];
            if (err != nil) {
                completitionBlock (nil,err);
            }
            else {
                completitionBlock (object,error);
            }
        });
    }];
    [task resume];
}

/*- (void)sendMessage:(NSDictionary*)params image:(UIImage*)image completition:(void (^)(id object, NSError *error))completitionBlock{
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    NSString *authToken = [[NSString alloc]initWithFormat:@"Bearer %@",[UmkaUser accessToken]];
        [manager.requestSerializer setValue:authToken forHTTPHeaderField:@"Authorization"];
    NSString *url = [NSString stringWithFormat:@"%@%@",K_API_DOMAIN_URL,K_API_SEND_MESSAGE];
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.7)
                                    name:@"pic" fileName:@"pic.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completitionBlock(responseObject,nil);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        id json;
        if (data)json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completitionBlock(json,error);
        });
    }];
}*/

#pragma mark - - -

- (void)uploadImageWithURL:(NSString*)url image:(UIImage*)image params:(NSDictionary*)params headers:(NSDictionary*)headers  complition:(void (^)(id object, NSError *error)) completitionBlock{
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    for (NSString *key in headers.allKeys)
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.7)
                                    name:@"pic" fileName:@"pic.jpg" mimeType:@"image/jpeg"];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completitionBlock(responseObject,nil);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        id json;
        if (data)json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completitionBlock(json,error);
        });
    }];
}

- (void)sendRequestWithURL:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers  complition:(void (^)(id object, NSError *error)) completitionBlock{
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    if ([params[@"http"] boolValue]==YES)manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/plain"];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    for (NSString *key in headers.allKeys)
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    [manager POST:url
       parameters:params
         progress:nil
          success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
              dispatch_async(dispatch_get_main_queue(), ^{
                  if ([responseObject isKindOfClass:[NSData class]]){
                      NSString *string = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                     completitionBlock( @{@"key":string},nil);
                  }
                  else completitionBlock(responseObject,nil);
              });
          }
          failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              NSData *data = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
              id json;
              if (data)json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
              dispatch_async(dispatch_get_main_queue(), ^{
                  completitionBlock(json,error);
              });
          }];
}

- (void)sendPUTRequestWithURL:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers  complition:(void (^)(id object, NSError *error)) completitionBlock{
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    for (NSString *key in headers.allKeys)
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completitionBlock(responseObject,nil);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        id json;
        if (data)json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completitionBlock(json,error);
        });
    }];
}

- (void)sendGETRequestWithURL:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers  complition:(void (^)(id object, NSError *error)) completitionBlock{
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    for (NSString *key in headers.allKeys)
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
    [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completitionBlock(responseObject,nil);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        id json;
        if (data)json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completitionBlock(json,error);
        });
    }];
}

- (void)sendDELETERequestWithURL:(NSString*)url params:(NSDictionary*)params headers:(NSDictionary*)headers  complition:(void (^)(id object, NSError *error)) completitionBlock{
    NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFHTTPSessionManager* manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:configuration];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"application/json"];
    for (NSString *key in headers.allKeys)
        [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
     [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completitionBlock(responseObject,nil);
        });
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSData *data = (NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey];
        id json;
        if (data)json = [NSJSONSerialization JSONObjectWithData:data
                                                        options:NSJSONReadingAllowFragments
                                                          error:&error];
        dispatch_async(dispatch_get_main_queue(), ^{
            completitionBlock(json,error);
        });
    }];
}


@end

