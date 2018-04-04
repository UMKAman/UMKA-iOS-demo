//
//  FilterCell.h
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterCell : UITableViewCell
@property (nonatomic, assign) BOOL openFilter;
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UIImageView *arrow;
@property (nonatomic, weak) IBOutlet UIView *bgView;
@property (nonatomic, strong) NSMutableArray *budges;
@property (nonatomic, weak) id delegate;
- (void)rebuildBudges;
@end
