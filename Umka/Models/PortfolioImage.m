//
//  PortfolioImage.m
//  Umka
//
//  Created by Ігор on 25.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "PortfolioImage.h"

@implementation PortfolioImage
- (id)initWithDict:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.id = dict[@"id"];
        self.pic =[NSString stringWithFormat:@"https://umka.city%@",dict[@"pic"]];
        self.portfolio = [[Portfolio alloc] initWithDict:dict];
    }
    return self;
}
@end
