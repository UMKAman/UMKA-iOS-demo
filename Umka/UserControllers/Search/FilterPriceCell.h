//
//  FilterPriceCell.h
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterPriceCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *priceLabel;
@property (nonatomic, weak) IBOutlet UILabel *priceKeyLabel;
@property (nonatomic, weak) IBOutlet UILabel *maxPriceLabel;
@property (nonatomic, weak) IBOutlet UISlider *priceSlider;
@property (nonatomic, weak) IBOutlet UIButton *clearBtn;
@property (nonatomic, weak) IBOutlet UIButton *applyBtn;
@property (nonatomic, weak) id delegate;
@end
