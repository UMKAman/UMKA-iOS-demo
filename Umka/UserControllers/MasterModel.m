//
//  UserFavouritesModel.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "MasterModel.h"
#import "Portfolio.h"

@implementation MasterModel

- (instancetype)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.id = dict[@"id"];
        self.user = ([dict[@"user"] isKindOfClass:[NSDictionary class]])?[[UserModel alloc] initWithDictionary:dict[@"user"]]:nil;
        self.minCost =([dict[@"minCost"] isKindOfClass:[NSNull class]])?@0:dict[@"minCost"];
        self.averageRating = ([dict[@"averageRating"] isKindOfClass:[NSNull class]])?@0:dict[@"averageRating"];
        self.lat = dict[@"lat"];
        self.lon = dict[@"lon"];
        self.visit = ([dict[@"visit"] isKindOfClass:[NSNull class]])?NO:[dict[@"visit"] boolValue];
        self.YO = dict[@"YO"];
        self.voices = ([dict[@"voices"] isKindOfClass:[NSNull class]])?@0:dict[@"voices"];
        self.ratingAndCouns = dict[@"ratingAndCouns"];
        self.specializations = [self parseSpecializations:dict[@"specializations"]];
        self.services = [self parseServices:dict[@"services"]];
        self.address = ([dict[@"address"] isKindOfClass:[NSNull class]])?NSLocalizedString(@"Адрес не указан",@""):dict[@"address"];
        self.atHome =([dict[@"atHome"] isKindOfClass:[NSNull class]])?NO:[dict[@"atHome"] boolValue];
        self.inFavorite = dict[@"inFavorite"];
        self.portfolios = [self parsePortfolios:dict[@"portfolios"]];
        self.isFav = [self detectInFav];
        self.reviews = ([dict[@"reviews"] isKindOfClass:[NSNull class]])?@[]:dict[@"reviews"];
        //self.aboutHeight = [self calculateAboutHeight];
    }
    return self;
}

- (NSArray*)parseSpecializations:(NSArray*)specializations{
    NSMutableArray *ta = [NSMutableArray new];
    for (NSDictionary *dict in specializations){
        CategoryModel *model = [[CategoryModel alloc] initWithDictionary:dict];
        [ta addObject:model];
    }
    return ta;
}

- (NSArray*)parseServices:(NSArray*)services{
    NSMutableArray *ta = [NSMutableArray new];
    for (NSDictionary *dict in services){
        Service  *model = [[Service alloc] initWithDictionary:dict];
        [ta addObject:model];
    }
    return ta;
}

- (NSArray*)parsePortfolios:(NSArray*)portfolios{
    NSMutableArray *ta = [NSMutableArray new];
    for (NSDictionary *dict in portfolios){
        Portfolio  *model = [[Portfolio alloc] initWithDict:dict];
        [ta addObject:model];
    }
    return ta;
}

- (BOOL)detectInFav{
    BOOL inFav = NO;
    for (NSDictionary *dict in self.inFavorite){
        if ([dict[@"id"] integerValue]==[UmkaUser userID]){
            inFav = YES;
            break;
        }
    }
    return inFav;
}


- (CGFloat)calculateAboutHeight
{
    CGRect r = [self.user.about boundingRectWithSize:CGSizeMake([UIScreen mainScreen].bounds.size.width-20, 5000)
                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                              attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]}
                                                 context:nil];
    return r.size.height;
}





@end
