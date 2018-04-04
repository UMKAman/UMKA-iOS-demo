//
//  CreatePortfolio.h
//  Umka
//
//  Created by Ігор on 24.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Portfolio.h"
@protocol CreatePortfolioDelegate;

@interface CreatePortfolio : UIViewController
@property (nonatomic, assign)BOOL editingMode;
@property (nonatomic, weak) id<CreatePortfolioDelegate>delegate;
@property (nonatomic, strong) MasterModel *master;
@property (nonatomic, strong) Portfolio *portfolio;
@property (nonatomic, weak) IBOutlet UITextField *name;
@property (nonatomic, weak) IBOutlet UICollectionView *collection;
@end

@protocol CreatePortfolioDelegate <NSObject>
- (void)portfolioDidCreated:(Portfolio*)portfolio;
- (void)portfolioDidChanged:(Portfolio*)portfolio;
@end
