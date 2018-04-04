//
//  SerdReviewCell.h
//  Umka
//
//  Created by Igor Zalisky on 12/7/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
#import "UserOrderModel.h"
#import "ReviewModel.h"
@interface SerdReviewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIView *textFieldBG;
@property (nonatomic, weak) IBOutlet UITextField *textField;
@property (nonatomic, weak) IBOutlet HCSStarRatingView *ratingView;
@property (nonatomic, strong) UserOrderModel *order;
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) ReviewModel* review;
@end
