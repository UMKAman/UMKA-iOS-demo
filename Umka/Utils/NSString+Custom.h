//
//  NSString+Custom.h
//  MVK
//
//  Created by Ігор on 15.08.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Custom)
- (BOOL)validateEmail;
- (NSDate*)dateWithFormat:(NSString*)format;
- (NSString *)encode;
@end
