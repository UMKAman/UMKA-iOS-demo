//
//  FilterLabelCell.h
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterLabelCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *titleLabel;
@property (nonatomic, weak) IBOutlet UILabel *subtitleLabel;
- (void)reloadCell;
@end