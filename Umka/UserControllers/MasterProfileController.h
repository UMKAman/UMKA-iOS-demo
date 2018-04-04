//
//  MasterProfileController.h
//  Umka
//
//  Created by Igor Zalisky on 12/19/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MasterModel;
@interface MasterProfileController : UITableViewController
@property (nonatomic, strong) MasterModel *model;
- (void)reloadAboutCell:(CGFloat)height;
@end
