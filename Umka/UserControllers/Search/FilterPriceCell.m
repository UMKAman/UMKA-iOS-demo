//
//  FilterPriceCell.m
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "FilterPriceCell.h"
#import "FilterManager.h"
#import "Constants.h"
#import "SearchFilterController.h"

@implementation FilterPriceCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.maxPriceLabel.text = K_FILTER_MAX_PRICE;
    self.priceLabel.text = [FilterManager price];
    self.priceSlider.value = [FilterManager price].floatValue/K_FILTER_MAX_PRICE.floatValue;
    [self.priceSlider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [self.clearBtn setTitle:NSLocalizedString(@"ОЧИСТИТЬ", @"") forState:UIControlStateNormal];
    [self.applyBtn setTitle:NSLocalizedString(@"ПРИМЕНИТЬ", @"") forState:UIControlStateNormal];
    self.priceKeyLabel.text = NSLocalizedString(@"ЦЕНА", @"");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (IBAction)sliderAction:(UISlider*)sender
{
    NSString *price = [NSString stringWithFormat:@"%.0f",K_FILTER_MAX_PRICE.floatValue*sender.value];
    self.priceLabel.text = price;
    [FilterManager savePrice:price];
}

- (IBAction)resetFilter:(UIButton*)sender
{
    [[self delegate] resetFilter];
    [FilterManager resetOptions];
}

- (IBAction)acceptFilter:(UIButton*)sender
{
    [self.delegate acceptFilter];
}

@end
