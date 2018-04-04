//
//  UserCategoryCell.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserCategoryCell.h"
#import "CategoryModel.h"
#import "Constants.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UserCategoryCell

- (void)setModel:(CategoryModel *)model
{
    if (self.model!=model)_model = model;
    self.categoryTitle.text = [model.name uppercaseString];
    //self.categoryIcon.image = [UIImage imageNamed:model.category_image];
    [self.categoryIcon sd_setImageWithURL:[NSURL URLWithString:model.pic] placeholderImage:nil];
    self.categoryIcon.backgroundColor = model.color;
    self.contentView.backgroundColor = model.color;
    self.categoryTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:13*SCALE_COOF];
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        self.categoryTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
}

@end
