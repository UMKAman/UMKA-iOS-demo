//
//  TemplateCell.m
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "TemplateCell.h"
#import "UserChatController.h"

@implementation TemplateCell

- (void)awakeFromNib {
    [super awakeFromNib];
  
    [self.favBtn setTitle:NSLocalizedString(@"В избранные", @"") forState:UIControlStateNormal];
    [self.messageBtn setTitle:NSLocalizedString(@"Сообщения", @"") forState:UIControlStateNormal];
    [self.callBtn setTitle:NSLocalizedString(@"Позвонить", @"") forState:UIControlStateNormal];
    [self.moreBtn setTitle:NSLocalizedString(@"Подробнее >", @"") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setModel:(MasterModel *)model
{
    if (self.model!=model)_model = model;
    self.name.text = model.user.name;
    self.rating.text = [NSString stringWithFormat:@"%@ (%@ %@)",model.averageRating,model.voices, [self reviewsWithCOunt:model.voices.integerValue]];
    self.ratingView.value = model.averageRating.floatValue;
    [self.master_avatar sd_setImageWithURL:[NSURL URLWithString:model.user.pic] placeholderImage:[UIImage imageNamed:@"ic_profile_no_avatar"]];
    self.favBtn.selected = model.isFav;
}

- (NSString*)reviewsWithCOunt:(NSInteger)count
{
    if (count%10==1 && count!=11) return NSLocalizedString(@"отзыв",@"");
    else if (count%10>1 &&count%10<5 && count!=12&& count!=13&& count!=14)return NSLocalizedString(@"отзыва",@"");
    else return NSLocalizedString(@"отзывов",@"");
}

- (IBAction)messagesAction:(id)sender {
    [[ApiManager new] getAllChatsCompletition:^(id response, NSError *error) {
        for (NSDictionary *dict in response){
            Dialog *d = [[Dialog alloc] initWithDictionary:dict];
            if (d.master.user.id.integerValue==self.model.user.id.integerValue){
                [self openChatWithDialog:d];
                return;
            }
        }
        [[ApiManager new] createChat:self.model.id completition:^(id response, NSError *error) {
            if (!error){
                [self createOrder];
                Dialog *d = [[Dialog alloc] initWithDictionary:response];
                [self openChatWithDialog:d];
            }
        }];
    }];
}


- (void)openChatWithDialog:(Dialog*)dialog{
    UserChatController *ucc = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"UserChatController"];
    ucc.dialog = dialog;
    [[self.delegate navigationController] pushViewController:ucc animated:YES];
}

- (IBAction)callAction:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.model.user.phone]]];
    [self createOrder];
}

- (void)createOrder{
    [[ApiManager new] createOrder:@{@"user":[NSNumber numberWithInteger:[UmkaUser userID]],@"master":self.model.id} completition:^(NSArray *response, NSError *error) {
        
    }];
}

@end
