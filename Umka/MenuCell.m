//
//  MenuCell.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "MenuCell.h"
#import "Constants.h"
#import "LeftMenuTable.h"
#import "UmkaUser.h"
#import "ApiManager.h"

@implementation MenuCell

- (void)awakeFromNib {
    [super awakeFromNib];
   // [self.modeSwitch addTarget:self action:@selector(changeMode:) forControlEvents:UIControlEventValueChanged];
    CGFloat dif = 10*SCALE_COOF;
    self.modeSwitch.frame = CGRectMake([UIScreen mainScreen].bounds.size.width*0.75-self.modeSwitch.frame.size.width-dif,
                                       self.modeSwitch.frame.origin.y,
                                       self.modeSwitch.frame.size.width,
                                       self.modeSwitch.frame.size.height);
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)changeMode:(UISwitch*)sender
{
    NSString *appMode = [UmkaUser appMode];
    if ([appMode isEqualToString:@"user"])appMode = @"master";
    else appMode = @"user";
    [UmkaUser saveAppMode:appMode];
    [[self delegate] reloadMainMenu];
    [[self delegate] selectRootController];
    self.modeSwitch.on = [appMode isEqualToString:@"master"];
    BOOL is_master = ([appMode isEqualToString:@"master"])?YES:NO;
    [[ApiManager new] updateUser:[NSNumber numberWithInteger:[UmkaUser userID]] params:@{@"isMaster":[NSNumber numberWithBool:is_master]} completition:^(id response, NSError *error) {
        if ([appMode isEqualToString:@"master"])[self findOrCreateMaster];
    }];

}

- (void)findOrCreateMaster{
    __block MasterModel *master;
    [[ApiManager new] getAllMastersCompletition:^(id response, NSError *error) {
        for (NSDictionary *dict in response){
            MasterModel *model = [[MasterModel alloc] initWithDictionary:dict];
            if (model.user.id.integerValue==[UmkaUser userID]){
                master = model;
                [UmkaUser saveMasterID:master.id.integerValue];
                
                break;
            }
        }
        if (!master){
            [[ApiManager new] createMasterCompletition:^(id response, NSError *error) {
                [UmkaUser saveMasterID:[response[@"id"] integerValue]];
            }];
        }
    }];
}

@end
