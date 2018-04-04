//
//  Workhour.m
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "Workhour.h"

@implementation Workhour
- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.id =dict[@"id"];
        NSString *dateStr = [dict[@"hour"] substringToIndex:19];
        NSDate *date = [dateStr dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        self.hour = [date stringWithFormat:@"H"];
        self.busy =[dict[@"busy"] boolValue];
    }
    return self;
}

@end
