//
//  FilterCell.m
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "FilterCell.h"
#import "FilterManager.h"
#import "SearchFilterController.h"
#import "Constants.h"

@implementation FilterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.budges = [[NSMutableArray alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setOpenFilter:(BOOL)openFilter
{
    [UIView animateWithDuration:0.33 animations:^{
        if (openFilter)
        {
            self.titleLabel.text = NSLocalizedString(@"Свернуть фильтр",@"");
            self.arrow.transform = CGAffineTransformMakeRotation(M_PI_2);
            self.bgView.alpha = 0.0;
        }
        else
        {
            CGRect frame = self.frame;
            if (self.budges.count==0)frame.size.height = 44;
            else frame.size.height = [self.budges.lastObject frame].origin.y+50;
            self.frame = frame;
            
            self.titleLabel.text = NSLocalizedString(@"Развернуть фильтр",@"");
            self.arrow.transform = CGAffineTransformIdentity;
            self.bgView.alpha = 1.0;
        }
    }];
}

- (void)rebuildBudges
{
    for (UIView *budge in self.budges)
        [budge removeFromSuperview];
    [self.budges removeAllObjects];
    
    if ([FilterManager toHome]==YES) [self budgeWithText:NSLocalizedString(@"Выезд на дом",@"") tag:0];
    if ([FilterManager InMaster]==YES) [self budgeWithText:NSLocalizedString(@"У специалиста",@"") tag:1];
    if ([FilterManager online]==YES) [self budgeWithText:NSLocalizedString(@"Онлайн",@"") tag:2];
    if ([FilterManager withReviews]==YES) [self budgeWithText:NSLocalizedString(@"Только с отзывами",@"") tag:3];
    
    CGRect frame = self.frame;
    if (self.budges.count==0)frame.size.height = 44;
    else frame.size.height = [self.budges.lastObject frame].origin.y+50;
    self.frame = frame;
    
    [self.delegate updateFilterData];
}

- (void)budgeWithText:(NSString*)text tag:(NSInteger)tag
{
    NSInteger col = self.budges.count%2;
    CGFloat xOffset = (col==0)?8.5*SCALE_COOF:[self.budges.lastObject frame].size.width+17*SCALE_COOF;
    NSInteger row = self.budges.count/2;
    UIView *v = [[UIView alloc] initWithFrame:CGRectMake(xOffset, 44+row*50+5, [self calculateWidthForText:text]+51*SCALE_COOF, 40)];
    v.backgroundColor = [self.delegate navigationController].navigationBar.barTintColor;
    v.layer.cornerRadius = 20.0;
    v.tag = tag;
    
    UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(8.5*SCALE_COOF, 0.0, [self calculateWidthForText:text], 40)];
    lbl.text = text;
    lbl.font = [UIFont systemFontOfSize:12*SCALE_COOF];
    lbl.textColor = [UIColor whiteColor];
    [v addSubview:lbl];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake([self calculateWidthForText:text]+17*SCALE_COOF, 0, 34*SCALE_COOF, 40)];
    [btn setImage:[UIImage imageNamed:@"ic_filter_bubble_remove"] forState:UIControlStateNormal];
    btn.tag = tag;
    [btn addTarget:self action:@selector(removeBudge:) forControlEvents:UIControlEventTouchUpInside];
    [v addSubview:btn];
    
    [self.contentView addSubview:v];
    [self.budges addObject:v];
}

- (void)removeBudge:(UIButton*)btn
{
    switch (btn.tag) {
        case 0:
        {
            [FilterManager saveToHomeOption:NO];
        }
            break;
        case 1:
        {
            [FilterManager saveInMasterOption:NO];
        }
            break;
        case 2:
        {
            [FilterManager saveOnlineOption:NO];
        }
            break;
        case 3:
        {
            [FilterManager saveWithReviewsOption:NO];
        }
            break;
            
        default:
            break;
    }
    [self.delegate acceptFilter];
}

- (CGFloat)calculateWidthForText:(NSString*)text
{
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12*SCALE_COOF]}];
    return textSize.width;
}

@end
