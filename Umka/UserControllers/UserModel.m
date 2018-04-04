//
//  UserModel.m
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.id = dict[@"id"];
        self.name = (![dict[@"name"] isKindOfClass:[NSNull class]])?dict[@"name"]:@"Аноним";
        self.about =(![dict[@"about"] isKindOfClass:[NSNull class]])? dict[@"about"]:@"";
        self.email =(![dict[@"email"] isKindOfClass:[NSNull class]])? dict[@"email"]:@"";
        self.phone =(![dict[@"phone"] isKindOfClass:[NSNull class]])? dict[@"phone"]:@"";
        self.gender=(![dict[@"gender"] isKindOfClass:[NSNull class]])? dict[@"gender"]:@"";
        self.pic = (![dict[@"avatar"] isKindOfClass:[NSNull class]])?[NSString stringWithFormat:@"https://umka.city%@",dict[@"avatar"]]:@"";
        self.rating = dict[@"rating"];
        self.city = (![dict[@"city"] isKindOfClass:[NSNull class]])? dict[@"city"]:@"";
        self.reviews = dict[@"reviews"];
        self.isMaster = [dict[@"isMaster"] boolValue];
    }
    return self;
}

- (UserModel*)updateUser:(NSDictionary*)dict{
    self.id = dict[@"id"];
    self.name = dict[@"name"];
    self.about = dict[@"about"];
    self.email = dict[@"email"];
    self.phone = dict[@"phone"];
    self.gender = dict[@"gender"];
    self.pic = (![dict[@"avatar"] isKindOfClass:[NSNull class]])?[NSString stringWithFormat:@"https://umka.city%@",dict[@"avatar"]]:@"";
    self.rating = dict[@"rating"];
    self.city = dict[@"city"];
    self.reviews = dict[@"reviews"];
    self.isMaster = [dict[@"isMaster"] boolValue];
    return self;
}

@end
