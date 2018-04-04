//
//  UserOrdersHistory.h
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UmkaTopTableViewController.h"
#import "UserOrderModel.h"
@interface UserOrdersHistory : UmkaTopTableViewController
- (void)sendReviewAction:(UserOrderModel*)order;
@end
