//
//  RatingModel.h
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@interface RatingModel : NSObject
@property (nonatomic, assign) NSInteger star5;
@property (nonatomic, assign) NSInteger star4;
@property (nonatomic, assign) NSInteger star3;
@property (nonatomic, assign) NSInteger star2;
@property (nonatomic, assign) NSInteger star1;
@property (nonatomic, assign) NSInteger allReviews;
@property (nonatomic, assign) CGFloat rating;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end
