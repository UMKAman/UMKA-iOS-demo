//
//  UserProfileController.h
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UmkaTopTableViewController.h"
@class UserModel;
@interface UserProfileController : UmkaTopTableViewController
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, assign) BOOL otherUser;
@end
