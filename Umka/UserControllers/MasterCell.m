//
//  MasterCell.m
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "MasterCell.h"
#import "CategoryModel.h"
#import "UserChatController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@implementation MasterCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.cellView.layer.masksToBounds = NO;
    self.cellView.layer.cornerRadius = 8;
    self.cellView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cellView.layer.shadowRadius = 5;
    self.cellView.layer.shadowOpacity = 0.25;
    self.master_avatar.layer.cornerRadius = self.master_avatar.frame.size.height/2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setModel:(MasterModel *)model
{
    [super setModel:model];

    self.master_spec.text = [self getServices:model.specializations];
    self.service1.text = [self serviceName:NO index:0];
    self.service2.text = [self serviceName:NO index:1];
    self.price1.text = [self serviceName:YES index:0];
    self.price2.text = [self serviceName:YES index:1];
}

- (NSString*)getServices:(NSArray*)services{
    NSMutableString *ms = [[NSMutableString alloc] initWithString:@""];
    for (CategoryModel *spec in services){
        if (ms.length==0)[ms appendString:spec.name];
        else [ms appendFormat:@", %@",spec.name];
    }
    return [ms copy];
}

- (NSString *)serviceName:(BOOL)price index:(NSInteger)index{
    NSString *rs = @"";
    if (self.model.services.count>index){
        Service *service = self.model.services[index];
        rs = service.name;
        if (price) rs = [NSString stringWithFormat:@"%@ ₽ / %@ %@",service.cost,service.count,service.measure];
    }
    return rs;
}


- (IBAction)favAction:(id)sender {
    if (!self.model.isFav){
    [[ApiManager new] addFavorite:[NSString stringWithFormat:@"%ld",[UmkaUser userID]] master_id:self.model.id completition:^(NSArray *obj, NSError* err) {
        self.model.isFav = !self.model.isFav;
        self.favBtn.selected = self.model.isFav;
    }];
    }
    else{
        [[ApiManager new] delFavorite:[NSString stringWithFormat:@"%ld",[UmkaUser userID]] master_id:self.model.id completition:^(NSArray *obj, NSError* err) {
            self.model.isFav = !self.model.isFav;
            self.favBtn.selected = self.model.isFav;
        }];
    }
    [[self.delegate tableView] reloadData];
}

- (IBAction)moreAction:(id)sender {
}

@end
