//
//  AccountInfoCell.h
//  Umka
//
//  Created by Ігор on 25.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountInfoCell : UITableViewCell
@property (nonatomic, strong) MasterModel *master;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, weak) IBOutlet UIButton *male;
@property (nonatomic, weak) IBOutlet UIButton *famale;
@property (nonatomic, weak) IBOutlet UISwitch *atHome;
@property (nonatomic, weak) IBOutlet UISwitch *visit;
@property (nonatomic, weak) IBOutlet UITextView *aboutView;
@property (nonatomic, weak) IBOutlet UILabel *phoneLabel;
@property (nonatomic, weak) IBOutlet UILabel *phoneKeyLabel;
@property (nonatomic, weak) IBOutlet UILabel *addressLabel;

@property (nonatomic, weak) IBOutlet UILabel *aboutLabel;
@property (nonatomic, weak) IBOutlet UILabel *genderLabel;
@property (nonatomic, weak) IBOutlet UILabel *genderKeyLabel;
@property (nonatomic, weak) IBOutlet UILabel *athomeLabel;
@property (nonatomic, weak) IBOutlet UILabel *visitLabel;
@property (nonatomic, weak) IBOutlet UILabel *athomeKeyLabel;
@property (nonatomic, weak) IBOutlet UILabel *visitKeyLabel;

@property (nonatomic, weak) id delegate;
@end
