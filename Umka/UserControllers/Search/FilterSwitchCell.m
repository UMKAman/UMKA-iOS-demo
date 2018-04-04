//
//  FilterSwitchCell.m
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "FilterSwitchCell.h"
#import "FilterManager.h"

@implementation FilterSwitchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.optionSwitch addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadCell
{
    switch (self.optionSwitch.tag) {
        case 5:
        {
            self.optionSwitch.on = [FilterManager toHome];
        }
            break;
        case 6:
        {
            self.optionSwitch.on = [FilterManager InMaster];
        }
            break;
        case 7:
        {
            self.optionSwitch.on = [FilterManager withReviews];
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)switchAction:(UISwitch*)sender
{
    switch (sender.tag) {
        case 5:
        {
            [FilterManager saveToHomeOption:sender.on];
        }
            break;
        case 6:
        {
             [FilterManager saveInMasterOption:sender.on];
        }
            break;
        case 7:
        {
            [FilterManager saveWithReviewsOption:sender.on];
        }
            break;
            
        default:
            break;
    }
}

@end
