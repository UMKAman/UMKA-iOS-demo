//
//  NSString+Custom.m
//  MVK
//
//  Created by Ігор on 15.08.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "NSString+Custom.h"

@implementation NSString (Custom)

- (BOOL)validateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

- (NSDate*)dateWithFormat:(NSString*)format {
    NSDateFormatter *df = [NSDateFormatter new];
    [df setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    [df setDateFormat:format];
    return [df dateFromString:self];
}

- (NSString *)encode {
    static NSMutableCharacterSet *chars = nil;
    static dispatch_once_t pred;
    
    if (chars)
        return [self stringByAddingPercentEncodingWithAllowedCharacters:chars];
    
    // to be thread safe
    dispatch_once(&pred, ^{
        chars = NSCharacterSet.URLQueryAllowedCharacterSet.mutableCopy;
        [chars removeCharactersInString:@"!*'();:@&=+$,/?%#[]"];
    });
    return [self stringByAddingPercentEncodingWithAllowedCharacters:chars];
}

@end
