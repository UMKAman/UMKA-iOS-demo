//
//  Portfolio.m
//  Umka
//
//  Created by Ігор on 24.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "Portfolio.h"

@implementation Portfolio
- (instancetype)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.id = dict[@"id"];
        self.descr = dict[@"description"];
    }
    return self;
}
@end
