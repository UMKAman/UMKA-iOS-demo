//
//  UserOrderHistoryCell.m
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserOrderHistoryCell.h"
#import "UserOrderModel.h"
#import "UserOrdersHistory.h"

@implementation UserOrderHistoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.cellView.layer.masksToBounds = NO;
    self.cellView.layer.cornerRadius = 8;
    self.cellView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cellView.layer.shadowRadius = 3;
    self.cellView.layer.shadowOpacity = 0.25;
    self.master_avatar.layer.cornerRadius = 20;
    self.master_avatar.clipsToBounds = YES;
    [self.reviewBtn setTitle:NSLocalizedString(@"Оставить отзыв", @"") forState:UIControlStateNormal];
    [self.moreBtn setTitle:NSLocalizedString(@"Подробнее >", @"") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(UserOrderModel *)model
{
    if (self.model!=model){
        _model = model;
        NSString *appMode = [UmkaUser appMode];
        if([appMode isEqualToString:@"user"]){
        self.name.text = model.master.user.name;
        self.date.text = model.date;
        [self.master_avatar sd_setImageWithURL:[NSURL URLWithString:model.master.user.pic] placeholderImage:[UIImage imageNamed:@"ic_profile_no_avatar"]];
        }
        else {
            self.name.text = model.user.name;
            self.date.text = model.date;
            [self.master_avatar sd_setImageWithURL:[NSURL URLWithString:model.user.pic] placeholderImage:[UIImage imageNamed:@"ic_profile_no_avatar"]];
        }
    }
}


- (IBAction)messagesAction:(id)sender {
    [[self delegate] sendReviewAction:self.model];
}

- (IBAction)moreAction:(id)sender {
}

@end
