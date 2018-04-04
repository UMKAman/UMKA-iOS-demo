//
//  Master.m
//  Umka
//
//  Created by Ігор on 10.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "Service.h"

@implementation Service

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.id = dict[@"id"];
        //self.visit = [dict[@"visit"] dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        self.cost = dict[@"cost"];
        self.measure = dict[@"measure"];
        self.count = dict[@"count"];
        self.currency = dict[@"currency"];
        self.name = dict[@"name"];
        self.master = [dict[@"master"] boolValue];
    }
    return self;
}
@end
