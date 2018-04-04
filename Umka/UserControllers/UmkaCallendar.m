//
//  UmkaCallendar.m
//  Umka
//
//  Created by Igor Zalisky on 12/20/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UmkaCallendar.h"
#import "CalendarView.h"
#import "AppDelegate.h"

@interface UmkaCallendar ()<CalendarViewDelegate>
@property (nonatomic, strong) CalendarView *calendarView;
@property (nonatomic, weak) IBOutlet UIView *contentView;

@property (nonatomic, weak) IBOutlet UILabel *yearLbl;
@property (nonatomic, weak) IBOutlet UILabel *dateLbl;
@property (nonatomic, weak) IBOutlet UILabel *chooseDate;

@property (nonatomic, weak) IBOutlet UIButton *closeBtn;
@property (nonatomic, weak) IBOutlet UIButton *okBtn;

@end

@implementation UmkaCallendar

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.closeBtn setTitle:NSLocalizedString(@"ЗАКРЫТЬ", @"") forState:UIControlStateNormal];
    [self.okBtn setTitle:NSLocalizedString(@"OK", @"") forState:UIControlStateNormal];
    self.chooseDate.text = NSLocalizedString(@"Выберите дату", @"");
    self.calendarView = [[CalendarView alloc] initWithPosition:0 y:115];
    self.calendarView.calendarDelegate = self;
    //self.calendarView.shouldShowHeaders = YES;
    self.calendarView.selectionColor = [UIColor colorWithRed:0.0 green:194.0/255.0 blue:104.0/255.0 alpha:1.000];
    self.calendarView.fontHeaderColor = [UIColor colorWithRed:63.0/255.0 green:81.0/255.0 blue:181.0/255.0 alpha:1.000];
    //self.calendarView.dayCellWidth = ([UIScreen mainScreen].bounds.size.width-60)/7;
    //self.calendarView.dayCellHeight = ([UIScreen mainScreen].bounds.size.width-60)/7;
    [self.contentView addSubview:self.calendarView];
    [self.calendarView refresh];
    
    self.contentView.layer.masksToBounds = NO;
    self.contentView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
    self.contentView.layer.shadowRadius = 15;
    self.contentView.layer.shadowOpacity = 0.6;
    self.contentView.layer.cornerRadius = 4;
    
    [self didChangeCalendarDate:self.calendarView.currentDate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)didChangeCalendarDate:(NSDate *)date
{
    self.selectedDate = date;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    self.yearLbl.text = [formatter stringFromDate:date];
    
    [formatter setDateFormat:@"EE, MMM d"];
    self.dateLbl.text = [formatter stringFromDate:date];
    [self.delegate calendarSelectDate:date];
}

- (IBAction)closeAction
{
    [self.delegate hideCalendar:NO];
}

- (IBAction)okAction:(id)sender
{
    [self.delegate hideCalendar:NO];
}

@end
