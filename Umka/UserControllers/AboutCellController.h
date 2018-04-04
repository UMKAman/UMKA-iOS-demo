//
//  AboutCellController.h
//  Umka
//
//  Created by Igor Zalisky on 12/21/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MasterModel;
@interface AboutCellController : UITableViewController
@property (nonatomic, strong) MasterModel *master;
@property (nonatomic, weak) id delegate;
@end
