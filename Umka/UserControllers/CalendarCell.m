//
//  CalendarCell.m
//  Umka
//
//  Created by Igor Zalisky on 12/19/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "CalendarCell.h"
#import "MasterModel.h"
#import "MasterProfileController.h"
#import "AppDelegate.h"
#import "ApiManager.h"

@implementation CalendarCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
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
        [self getTimesForDate:[NSDate date]];
    }
}

- (void)setupHours:(NSArray*)availibleTimes
{
    if (!self.buttons)self.buttons = [[NSMutableArray alloc] init];
    for (UIButton *btn in self.buttons)
        [btn removeFromSuperview];
    [self.buttons removeAllObjects];
    
    for (NSInteger i=0; i<14; i++)
    {
        NSString *time = [NSString stringWithFormat:@"%ld:00-%ld:00",i+8,i+9];
        BOOL availibleTime = ([availibleTimes containsObject:time]);
        CGFloat offsetX = 40;
        if (i>6) offsetX = self.contentView.frame.size.width/2+10+20;
        CGFloat offsetY = 40+i*30;
        if (i>6)offsetY = 40+(i-7)*30;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, offsetY, self.contentView.frame.size.width/2-10, 30)];
        [btn setTitle:time forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        //[btn setEnabled:availibleTime];
        if (self.cellView.subviews)[self.cellView addSubview:btn];
        else [self.contentView addSubview:btn];
        [self.buttons addObject:btn];
    }
}

- (IBAction)showCalendar:(id)sender
{
    //[[AppDelegate sharedDelegate] showCalendar:self];
}

- (void)updateDate:(NSDate*)date
{
    BOOL today = [[NSCalendar currentCalendar] isDateInToday:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EE, MMM d"];
    NSString *title = (today)?NSLocalizedString(@"Сегодня", @""):[formatter stringFromDate:date];
    [self.calendarBtn setTitle:title forState:UIControlStateNormal];
    self.calendarBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -self.calendarBtn.imageView.frame.size.width, 0, self.calendarBtn.imageView.frame.size.width);
    self.calendarBtn.imageEdgeInsets = UIEdgeInsetsMake(0, self.calendarBtn.titleLabel.frame.size.width, 0, -self.calendarBtn.titleLabel.frame.size.width);
    [self getTimesForDate:date];
}

- (void)getTimesForDate:(NSDate*)date
{
    NSTimeInterval ti = [date timeIntervalSince1970];
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%.0f",ti],@"day",
                                 [NSString stringWithFormat:@"%ld",(long)self.master.id],@"profileid",nil];
    
    [[ApiManager new] getAvailibleTimesForDay:dict completition:^(NSArray *array, NSError *err) {
        [self setupHours:array];
    }];
}


@end
