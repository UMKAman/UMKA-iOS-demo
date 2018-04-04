//
//  UserNotificationsModel.h
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserNotificationsModel : NSObject
@property (nonatomic, strong) NSString *notif_id;
@property (nonatomic, strong) NSString *notif_name;
@property (nonatomic, strong) NSString *notif_count;
@property (nonatomic, strong) NSString *notif_message;
@property (nonatomic, strong) NSString *notif_subject;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end
