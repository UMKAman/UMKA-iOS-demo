//
//  ReviewModel.h
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ReviewModel : NSObject
@property (nonatomic, strong) NSString *review_id;
@property (nonatomic, strong) NSString *review_rating;
@property (nonatomic, strong) NSString *review_date;
@property (nonatomic, strong) NSString *review_message;
@property (nonatomic, strong) UserModel *user;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end
