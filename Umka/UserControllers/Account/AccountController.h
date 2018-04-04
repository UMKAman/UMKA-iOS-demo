//
//  UserProfileController.h
//  7Cases
//
//  Created by Igor Zalisky on 2/5/17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UmkaTopViewController.h"

@interface AccountController : UmkaTopViewController
@property (nonatomic, assign) BOOL editingMode;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) MasterModel *master;
@end
