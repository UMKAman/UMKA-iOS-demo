//
//  AccountPortfolio.h
//  Umka
//
//  Created by Ігор on 24.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountPortfolio : UITableViewController
@property (nonatomic, assign)BOOL editingMode;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) MasterModel *master;
- (void)removePortfolio:(NSIndexPath*)indexPath;
- (void)editPortfolio:(NSIndexPath*)indexPath;
@end
