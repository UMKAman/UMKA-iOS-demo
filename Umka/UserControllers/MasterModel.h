//
//  UserFavouritesModel.h
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MasterModel : NSObject

@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *minCost;
@property (nonatomic, strong) NSNumber *averageRating;
@property (nonatomic, strong) NSNumber *lat;
@property (nonatomic, strong) NSNumber *lon;
@property (nonatomic, assign) BOOL visit;
@property (nonatomic, strong) NSString *YO;
@property (nonatomic, strong) NSDictionary *ratingAndCouns;
@property (nonatomic, strong) NSNumber *voices;
@property (nonatomic, strong) NSArray *specializations;
@property (nonatomic, strong) NSArray *services;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) BOOL atHome;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) NSArray *inFavorite;
@property (nonatomic, strong) NSArray *portfolios;
@property (nonatomic, strong) NSArray *reviews;
@property (nonatomic, assign) BOOL isFav;

@property (nonatomic, assign) CGFloat aboutHeight;

- (CGFloat)calculateAboutHeight;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end

