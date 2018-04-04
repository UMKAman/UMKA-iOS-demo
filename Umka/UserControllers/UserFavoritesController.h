//
//  UserFavoritesController.h
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UmkaTopTableViewController.h"
#import "MasterModel.h"
@interface UserFavoritesController : UmkaTopTableViewController
- (void)delMaster:(MasterModel*)master;
@end
