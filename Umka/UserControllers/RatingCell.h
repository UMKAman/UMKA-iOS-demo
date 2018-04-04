//
//  RatingCell.h
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <YLProgressBar/YLProgressBar.h>
#import <HCSStarRatingView/HCSStarRatingView.h>
@class RatingModel;
@interface RatingCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet YLProgressBar *progress5Star;
@property (weak, nonatomic) IBOutlet YLProgressBar *progress4Star;
@property (weak, nonatomic) IBOutlet YLProgressBar *progress3Star;
@property (weak, nonatomic) IBOutlet YLProgressBar *progress2Star;
@property (weak, nonatomic) IBOutlet YLProgressBar *progressStar;
@property (weak, nonatomic) IBOutlet UILabel *count5star;
@property (weak, nonatomic) IBOutlet UILabel *count4star;
@property (weak, nonatomic) IBOutlet UILabel *count3star;
@property (weak, nonatomic) IBOutlet UILabel *count2star;
@property (weak, nonatomic) IBOutlet UILabel *count1star;
@property (weak, nonatomic) IBOutlet HCSStarRatingView *ratingView;
@property (weak, nonatomic) IBOutlet UILabel *allReviews;
@property (weak, nonatomic) IBOutlet UILabel *rating;

@property (nonatomic, strong) RatingModel *ratingModel;

@end
