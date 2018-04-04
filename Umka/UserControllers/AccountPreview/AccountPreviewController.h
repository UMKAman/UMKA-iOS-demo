//
//  AccountPreviewController.h
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UmkaTopViewController.h"
@interface AccountPreviewController : UmkaTopViewController
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, strong) MasterModel *master;
@end
