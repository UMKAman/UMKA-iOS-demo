//
//  UserNotificationsModel.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserNotificationsModel.h"

@implementation UserNotificationsModel
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.notif_id = dict[@"id"];
        self.notif_name = dict[@"name"];
        self.notif_count = dict[@"count"];
        self.notif_message = dict[@"message"];
        self.notif_subject = dict[@"subject"];
    }
    return self;
}
@end
