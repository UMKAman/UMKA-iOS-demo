//
//  UserMastersList.h
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"
@interface UserMastersList : UITableViewController
@property (nonatomic, strong) CategoryModel *model;
@end
