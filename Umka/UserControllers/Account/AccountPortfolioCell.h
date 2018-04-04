//
//  AccountPortfolioCell.h
//  Umka
//
//  Created by Ігор on 24.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Portfolio.h"
@interface AccountPortfolioCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UICollectionView *collection;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) Portfolio *portfolio;
@property (nonatomic, strong) NSIndexPath *indexPath;
- (void)reloadImages;
@end
