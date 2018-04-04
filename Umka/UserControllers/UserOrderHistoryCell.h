//
//  UserOrderHistoryCell.h
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserOrderModel;
@interface UserOrderHistoryCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIView *cellView;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *date;
@property (nonatomic, weak) IBOutlet UIButton *reviewBtn;
@property (nonatomic, weak) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIImageView *master_avatar;
@property (nonatomic, strong) UserOrderModel *model;
@property (nonatomic, weak) id delegate;
@end
