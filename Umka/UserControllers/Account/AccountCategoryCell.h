//
//  AccountCategoryCell.h
//  Umka
//
//  Created by Ігор on 24.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountCategoryCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *parent;
@property (nonatomic, weak) IBOutlet UIImageView *icon;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *parentHeight;
@property (nonatomic, strong) CategoryModel *category;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, weak) id delegate;
@end
