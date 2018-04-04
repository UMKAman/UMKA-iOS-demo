//
//  Workday.h
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Workday : NSObject
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,strong) NSString *date;
@property (nonatomic,strong) NSArray *workhours;
- (id)initWithDict:(NSDictionary*)dict;
@end
