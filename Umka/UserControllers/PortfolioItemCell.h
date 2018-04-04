//
//  PortfolioItemCell.h
//  Umka
//
//  Created by Igor Zalisky on 12/19/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PortfolioItemCell : UICollectionViewCell
@property (nonatomic, weak) IBOutlet UILabel *text;
@property (nonatomic, weak) IBOutlet UIImageView *image;
@property (nonatomic, weak) IBOutlet UIButton *btn;
@property (nonatomic, strong) NSDictionary *item;
@end
