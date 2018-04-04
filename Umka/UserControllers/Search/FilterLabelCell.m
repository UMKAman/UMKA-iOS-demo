//
//  FilterLabelCell.m
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "FilterLabelCell.h"
#import "Constants.h"
#import "FilterManager.h"
#import "UmkaUser.h"

@implementation FilterLabelCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadCell
{
    self.titleLabel.text = K_FILTER_ITEMS[self.tag];
    switch (self.tag) {
        case 1:
        {
            NSInteger index = [FilterManager sortBy];
            self.subtitleLabel.text = K_FILTER_SORTING_ITEMS[index];
        }
            break;
        case 2:
        {
            NSDictionary *spec = [FilterManager spec];
            if (!spec) self.subtitleLabel.text = NSLocalizedString(@"Не выбрано",@"");
            else self.subtitleLabel.text = spec[@"name"];
        }
            break;
        case 3:
        {
            NSInteger index = [FilterManager gender];
            self.subtitleLabel.text = K_FILTER_GENDER_ITEMS[index];
        }
            break;
        case 4:
        {
            self.subtitleLabel.text = [FilterManager city][@"city"];
        }
            break;
            
        default:
            break;
    }
}

@end
