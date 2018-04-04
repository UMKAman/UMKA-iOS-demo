//
//  Workhour.h
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Workhour : NSObject
@property (nonatomic,strong) NSNumber *id;
@property (nonatomic,strong) NSString *hour;
@property (nonatomic,assign) BOOL busy;
- (id)initWithDict:(NSDictionary*)dict;
@end
