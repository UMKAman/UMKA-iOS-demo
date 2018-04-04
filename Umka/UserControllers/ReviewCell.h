//
//  ReviewCell.h
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"
@class ReviewModel;
@interface ReviewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIView *cellView;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *date;
@property (nonatomic, weak) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) IBOutlet HCSStarRatingView *ratingView;

@property (nonatomic, strong) ReviewModel *model;
@property (nonatomic, weak) id delegate;
@end
