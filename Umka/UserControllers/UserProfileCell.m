//
//  UserProfileCell.m
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserProfileCell.h"
#import "UserModel.h"
#import "UmkaUser.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation UserProfileCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cellView.layer.masksToBounds = NO;
    self.cellView.layer.cornerRadius = 8;
    self.cellView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cellView.layer.shadowRadius = 5;
    self.cellView.layer.shadowOpacity = 0.25;
    
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setUser:(UserModel *)user
{
    if (self.user!=user){
        _user = user;
    }
    self.name.text = self.user.name;
    [self.emailBtn setTitle:self.user.email forState:UIControlStateNormal];
    [self.phoneBtn setTitle:self.user.phone forState:UIControlStateNormal];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.user.pic] placeholderImage:[UIImage imageNamed:@"side_nav_no_avatar"]];
}


- (IBAction)callAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.user.phone]]];
}

- (IBAction)messagesAction:(id)sender {
    if (!self.user){
        
    }
    else{
        
    }
}



@end
