//
//  ReviewCell.m
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "ReviewCell.h"
#import "ReviewModel.h"
@implementation ReviewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self layoutIfNeeded];
    self.cellView.layer.masksToBounds = NO;
    self.cellView.layer.cornerRadius = 8;
    self.cellView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cellView.layer.shadowRadius = 3;
    self.cellView.layer.shadowOpacity = 0.1;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height/2.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(ReviewModel *)model
{
    if (self.model!=model){
        _model = model;
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:model.user.pic] placeholderImage:self.avatar.image];
    }
    self.name.text = model.user.name;
    self.date.text = model.review_date;
    self.message.text = model.review_message;
    self.ratingView.value = model.review_rating.floatValue;
}
@end
