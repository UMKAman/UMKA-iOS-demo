//
//  PortfolioCell.h
//  Umka
//
//  Created by Igor Zalisky on 12/19/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MasterModel;
@interface PortfolioCell : UITableViewCell<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, weak) IBOutlet UICollectionView *portfolio;
@property (nonatomic, weak) IBOutlet UILabel *title;
@property (nonatomic, weak) IBOutlet UILabel *infoCell;
@property (nonatomic, weak) IBOutlet UILabel *spec1;
@property (nonatomic, weak) IBOutlet UILabel *spec2;
@property (nonatomic, weak) IBOutlet UILabel *price1;
@property (nonatomic, weak) IBOutlet UILabel *price2;
@property (nonatomic, weak) IBOutlet UIButton *allPrices;
@property (nonatomic, weak) IBOutlet UIView *cellView;
@property (nonatomic, strong) MasterModel *master;
@property (nonatomic, weak) id delegate;

@property (nonatomic, assign) BOOL editMode;
@end
