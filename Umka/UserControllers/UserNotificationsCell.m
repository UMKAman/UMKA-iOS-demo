//
//  UserNotificationsCell.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserNotificationsCell.h"
#import "UserNotificationsModel.h"

@implementation UserNotificationsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bluePoint.layer.cornerRadius = 6.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(UserNotificationsModel *)model
{
    if (self.model!=model)_model = model;
    self.name.text = model.notif_name;
    self.count.text = [NSString stringWithFormat:@"%@ %@",model.notif_count,[self messagesWithCount:model.notif_count.integerValue]];
    self.message.text = model.notif_message;
}

- (NSString*)messagesWithCount:(NSInteger)count
{
    if (count%10==1 && count!=11) return NSLocalizedString(@"новое сообщение",@"");
    else if (count%10>1 &&count%10<5 && count!=12&& count!=13&& count!=14)return NSLocalizedString(@"новых сообщения",@"");
    else return NSLocalizedString(@"новых сообщений",@"");
}

@end
