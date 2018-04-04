//
//  PortfolioItemCell.m
//  Umka
//
//  Created by Igor Zalisky on 12/19/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "PortfolioItemCell.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation PortfolioItemCell

- (void)setItem:(NSDictionary *)item
{
    if (self.item !=item)
    {
        _item = item;
        self.image.image = [UIImage imageNamed:@"image_specialist_profile_photo_placeholder"];
        if (![item[@"image"]  isKindOfClass:[NSNull class]])
        {
            NSString *img = [NSString stringWithFormat:@"http://mirumka.ru/images/portfolio/%@",item[@"image"]];
            [self.image sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"image_specialist_profile_photo_placeholder"]];
        }
        if (![item[@"description"]  isKindOfClass:[NSNull class]])self.text.text = item[@"description"];
        else self.text.text = @"";
        
    }
}

@end
