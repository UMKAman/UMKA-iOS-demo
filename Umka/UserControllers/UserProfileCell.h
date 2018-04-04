//
//  UserProfileCell.h
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;
@interface UserProfileCell : UITableViewCell
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, weak) IBOutlet UIView *cellView;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UIButton *phoneBtn;
@property (nonatomic, weak) IBOutlet UIButton *emailBtn;
@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) id delegate;
@end
