//
//  AboutCell.m
//  Umka
//
//  Created by Igor Zalisky on 12/19/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "AboutCell.h"
#import "MasterModel.h"
#import "AboutCellController.h"
#import "MasterProfileController.h"

@interface AboutCell ()
@property (nonatomic, strong) AboutCellController *aboutCellController;
@end

@implementation AboutCell

- (void)awakeFromNib {
    [super awakeFromNib];
    CGRect frame = self.frame;
    frame.size.width = [UIScreen mainScreen].bounds.size.width;
    self.frame = frame;
    
    CGRect frame1 = self.cellView.frame;
    frame1.size.width = [UIScreen mainScreen].bounds.size.width-12;
    self.cellView.frame = frame1;
    
    self.cellView.layer.masksToBounds = NO;
    self.cellView.layer.cornerRadius = 8;
    self.cellView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cellView.layer.shadowRadius = 5;
    self.cellView.layer.shadowOpacity = 0.25;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMaster:(MasterModel *)master
{
    if (self.master!=master)
    {
        _master = master;
        [self setupAboutInfo];
    }
    self.aboutCellController.view.frame = CGRectMake(-6.0, 0.0, [UIScreen mainScreen].bounds.size.width, self.frame.size.height);
}

- (void)setupAboutInfo
{
    self.aboutCellController = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AboutCellController"];
    self.aboutCellController.view.frame = CGRectMake(-6.0, 0.0, self.aboutCellController.view.frame.size.width, self.frame.size.height);
    self.aboutCellController.master = self.master;
    self.aboutCellController.delegate = self;
    [self.cellView addSubview:self.aboutCellController.view];
    self.cellView.clipsToBounds = YES;
}

- (void)reloadCell:(CGFloat)height
{
    [self.delegate reloadAboutCell:height];
}




@end
