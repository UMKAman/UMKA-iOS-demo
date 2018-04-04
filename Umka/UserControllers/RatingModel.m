//
//  RatingModel.m
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "RatingModel.h"

@implementation RatingModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        for (NSString *key in dict.allKeys){
            if (key.integerValue==5)
                self.star5 = self.star5+[dict[key] integerValue];
            if (key.integerValue==4)
                self.star4 = self.star4+[dict[key] integerValue];
            if (key.integerValue==3)
                self.star3 = self.star3+[dict[key] integerValue];
            if (key.integerValue==2)
                self.star2 = self.star2+[dict[key] integerValue];
            if (key.integerValue==1)
                self.star1 = self.star1+[dict[key] integerValue];
        }
        self.allReviews = self.star1+self.star2+self.star3+self.star4+self.star5;
        self.rating = (float)(self.star5*5+self.star4*4+self.star3*3+self.star2*2+self.star1)/(float)self.allReviews;
        if (self.allReviews==0)self.rating = 0.0;
    }
    return self;
}

@end
