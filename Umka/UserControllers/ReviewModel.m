//
//  ReviewModel.m
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "ReviewModel.h"

@implementation ReviewModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.review_id = dict[@"id"];
        self.review_date = dict[@"date"];
        self.review_rating = dict[@"rating"];
        self.review_message = dict[@"text"];
        self.user = [[UserModel alloc] initWithDictionary:dict[@"writter"]];
    }
    return self;
}


@end
