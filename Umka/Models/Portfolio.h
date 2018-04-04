//
//  Portfolio.h
//  Umka
//
//  Created by Ігор on 24.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Portfolio : NSObject
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *descr;
@property (nonatomic, strong) NSArray *images;
- (instancetype)initWithDict:(NSDictionary*)dict;
@end
