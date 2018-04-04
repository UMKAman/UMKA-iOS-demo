//
//  MainMasterController.h
//  Umka
//
//  Created by Igor Zalisky on 12/23/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MasterModel;
@interface MainMasterController : UITableViewController
@property (nonatomic, strong) MasterModel *master;
@property (nonatomic, strong) UserModel *user;
@end
