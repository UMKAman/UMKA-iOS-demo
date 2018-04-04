//
//  UserNotificationsCell.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserMessagesCell.h"
#import "UserNotificationsModel.h"

@implementation UserMessagesCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.bluePoint.layer.cornerRadius = 6.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(Dialog *)model
{
    if (self.model!=model)_model = model;
    self.name.text =  ([[UmkaUser appMode] isEqualToString:@"user"])?model.master.user.name:model.user.name;
    self.count.text = [NSString stringWithFormat:@"%ld %@",model.messages.count,[self messagesWithCount:model.messages.count]];
    self.message.text = [model.messages.lastObject text];
}

- (NSString*)messagesWithCount:(NSInteger)count
{
    if (count%10==1 && count!=11) return NSLocalizedString(@"новое сообщение",@"");
    else if (count%10>1 &&count%10<5 && count!=12&& count!=13&& count!=14)return NSLocalizedString(@"новых сообщения",@"");
    else return NSLocalizedString(@"новых сообщений",@"");
}

@end
