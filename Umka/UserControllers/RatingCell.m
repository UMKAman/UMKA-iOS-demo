//
//  RatingCell.m
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "RatingCell.h"
#import "RatingModel.h"

@implementation RatingCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cellView.layer.masksToBounds = NO;
    self.cellView.layer.cornerRadius = 8;
    self.cellView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cellView.layer.shadowRadius = 5;
    self.cellView.layer.shadowOpacity = 0.25;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setRatingModel:(RatingModel *)ratingModel
{
    self.progress5Star.progress = (float)ratingModel.star5/(float)ratingModel.allReviews;
    self.progress4Star.progress = (float)ratingModel.star4/(float)ratingModel.allReviews;
    self.progress3Star.progress = (float)ratingModel.star3/(float)ratingModel.allReviews;
    self.progress2Star.progress = (float)ratingModel.star2/(float)ratingModel.allReviews;
    self.progressStar.progress  = (float)ratingModel.star1/(float)ratingModel.allReviews;
    
    self.count1star.text = [NSString stringWithFormat:@"%ld",ratingModel.star1];
    self.count2star.text = [NSString stringWithFormat:@"%ld",ratingModel.star2];
    self.count3star.text = [NSString stringWithFormat:@"%ld",ratingModel.star3];
    self.count4star.text = [NSString stringWithFormat:@"%ld",ratingModel.star4];
    self.count5star.text = [NSString stringWithFormat:@"%ld",ratingModel.star5];
    
    self.allReviews.text = [NSString stringWithFormat:@"%ld %@",ratingModel.allReviews, [self reviewsWithCOunt:ratingModel.allReviews]];
    
    self.rating.text = [NSString stringWithFormat:@"%.1f",ratingModel.rating];
    self.ratingView.value = ratingModel.rating;
}

- (NSString*)reviewsWithCOunt:(NSInteger)count
{
    if (count%10==1 && count!=11) return NSLocalizedString(@"отзыв",@"");
    else if (count%10>1 &&count%10<5 && count!=12&& count!=13&& count!=14)return NSLocalizedString(@"отзыва",@"");
    else return NSLocalizedString(@"отзывов",@"");
}

@end
