//
//  PortfolioImage.h
//  Umka
//
//  Created by Ігор on 25.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Portfolio.h"
@interface PortfolioImage : NSObject
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) Portfolio *portfolio;
- (id)initWithDict:(NSDictionary*)dict;
@end
