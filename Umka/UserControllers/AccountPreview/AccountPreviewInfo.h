//
//  AccountPreviewInfo.h
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountPreviewInfo : UITableViewController
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) MasterModel *master;
@property (nonatomic, strong) UserModel *user;
@end
