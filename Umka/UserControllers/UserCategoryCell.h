//
//  UserCategoryCell.h
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CategoryModel;
@interface UserCategoryCell : UICollectionViewCell
@property (nonatomic, strong) CategoryModel *model;
@property (nonatomic, weak) IBOutlet UILabel *categoryTitle;
@property (nonatomic, weak) IBOutlet UIImageView *categoryIcon;
@end
