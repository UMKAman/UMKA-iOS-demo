//
//  UserFavouritesCell.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserFavouritesCell.h"
#import "MasterModel.h"
#import "UserChatController.h"
#import "UserFavoritesController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UserFavouritesCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.cellView.layer.masksToBounds = NO;
    self.cellView.layer.cornerRadius = 8;
    self.cellView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cellView.layer.shadowRadius = 5;
    self.cellView.layer.shadowOpacity = 0.25;
    self.master_avatar.layer.cornerRadius = 20;
    self.master_avatar.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)favAction:(id)sender {
    self.model.isFav = NO;
    self.favBtn.selected = self.model.isFav;
    [self.delegate delMaster:self.model];
}


- (IBAction)moreAction:(id)sender {
}
@end
