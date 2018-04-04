//
//  Workday.m
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "Workday.h"
#import "Workhour.h"

@implementation Workday
- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.id = dict[@"id"];
        self.date = dict[@"date"];
        self.workhours = [self parseWorkhours:dict[@"workhours"]];
    }
    return self;
}

- (NSArray*)parseWorkhours:(NSArray*)hours{
    NSMutableArray *na = [NSMutableArray new];
    for (NSDictionary *hour in hours){
        Workhour *wh = [[Workhour alloc] initWithDict:hour];
        [na addObject:wh];
    }
    return na;
}

@end
