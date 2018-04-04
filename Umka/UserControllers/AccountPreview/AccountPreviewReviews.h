//
//  AccountPreviewReviews.h
//  Umka
//
//  Created by Ігор on 27.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AccountPreviewReviews : UITableViewController
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) MasterModel *master;
@property (nonatomic, assign) BOOL isRating;
@end
