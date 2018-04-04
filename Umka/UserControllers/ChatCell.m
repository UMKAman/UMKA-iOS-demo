//
//  ChatCell.m
//  Umka
//
//  Created by Igor Zalisky on 12/11/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "ChatCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UserChatController.h"

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
   if (self.avatar)
   {
       self.avatar.layer.cornerRadius = 15.0;
   }
    self.messageBG.layer.cornerRadius = 35/2;
    self.photo.layer.cornerRadius = 35/2;
    self.photo.userInteractionEnabled = YES;
    UITapGestureRecognizer *singleFingerTap =
    [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleSingleTap:)];
    [self.photo addGestureRecognizer:singleFingerTap];
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    [self.delegate setupPhotoBrouser:self.model.pic];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(Message *)model
{
    if (self.model!=model)
    {
        _model = model;
        NSString *appMode = [UmkaUser appMode];
        if ([appMode isEqualToString:@"user"]){
            self.user.text = self.dialog.master.user.name;
            [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.dialog.master.user.pic] placeholderImage:[UIImage imageNamed:@"ic_chat_no_avatar"]];
        }
        else {
            self.user.text = self.dialog.user.name;
            [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.dialog.user.pic] placeholderImage:[UIImage imageNamed:@"ic_chat_no_avatar"]];
        }
        if (!model.pic || model.pic.length==0){
            self.message.numberOfLines = 0;
            self.message.text =model.text;;
            self.photo.image = nil;
        }
        else self.message.text =@"";
        
        [self.photo sd_setImageWithURL:[NSURL URLWithString:_model.pic]];
        
        self.status.text = NSLocalizedString(@"Отправлено", @"");
    }

}

@end
