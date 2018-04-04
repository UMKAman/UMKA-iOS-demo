//
//  NSDate+Custom.m
//  MVK
//
//  Created by Ігор on 16.08.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "NSDate+Custom.h"

@implementation NSDate (Custom)

- (NSString*)stringWithFormat:(NSString*)format
{
    NSDateFormatter *df = [NSDateFormatter new];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [df setDateFormat:format];
    return [df stringFromDate:self];
}
@end
