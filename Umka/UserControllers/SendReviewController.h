//
//  SendReviewController.h
//  Umka
//
//  Created by Igor Zalisky on 12/7/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserOrderModel.h"
@interface SendReviewController : UITableViewController
@property (nonatomic, strong) UserOrderModel *order;
- (void)loadReviews;
@end
