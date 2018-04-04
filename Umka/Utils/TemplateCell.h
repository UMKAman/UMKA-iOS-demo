//
//  TemplateCell.h
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <HCSStarRatingView/HCSStarRatingView.h>
@interface TemplateCell : UITableViewCell
@property (nonatomic, weak) IBOutlet HCSStarRatingView *ratingView;
@property (nonatomic, weak) IBOutlet UIButton *favBtn;
@property (nonatomic, weak) IBOutlet UIButton *messageBtn;
@property (nonatomic, weak) IBOutlet UIButton *callBtn;
@property (nonatomic, weak) IBOutlet UIButton *moreBtn;
@property (weak, nonatomic) IBOutlet UIImageView *master_avatar;
@property (nonatomic, strong) MasterModel *model;
@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *rating;
@end
