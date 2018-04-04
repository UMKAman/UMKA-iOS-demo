//
//  Master.h
//  Umka
//
//  Created by Ігор on 10.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Service : NSObject
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *cost;
@property (nonatomic, strong) NSString *measure;
@property (nonatomic, strong) NSNumber *count;
@property (nonatomic, strong) NSString *currency;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL master;
- (id)initWithDictionary:(NSDictionary*)dict;
@end
