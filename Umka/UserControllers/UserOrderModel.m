//
//  UserOrderModel.m
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserOrderModel.h"

@implementation UserOrderModel
- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.id = dict[@"id"];
        self.date = [self dateString:dict[@"createdAt"]];
        self.master = [[MasterModel alloc] initWithDictionary:dict[@"master"]];
        self.user =[[UserModel alloc] initWithDictionary:dict[@"user"]];
        self.masterApprove = [dict[@"masterApprove"] boolValue];
    }
    return self;
}

- (NSString*)dateString:(NSString*)ds{
    if ([ds isKindOfClass:[NSNull class]])return @"";
    NSDate *date = [ds dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    return [date stringWithFormat:@"d MMM, HH:mm"];
}

@end
