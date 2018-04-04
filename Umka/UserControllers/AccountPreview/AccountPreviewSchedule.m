//
//  AccountPreviewSchedule.m
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountPreviewSchedule.h"
#import "UmkaCallendar.h"
#import "Workday.h"
#import "Workhour.h"

@interface AccountPreviewSchedule ()<CalendarDelegate>
@property (nonatomic, weak) IBOutlet UIButton *calendarBtn;
@property (nonatomic, weak) IBOutlet UILabel *availibleHours;
@property (nonatomic, strong) NSMutableArray *buttons;
@property (nonatomic, strong) UmkaCallendar *calendar;
@property (nonatomic, strong) NSMutableArray *workdays;
@property (nonatomic, strong) Workday *selectedWorkday;

@end

@implementation AccountPreviewSchedule

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    self.title = NSLocalizedString(@"График занятости", @"");
    self.availibleHours.text = NSLocalizedString(@"Свободные часы", @"");
    NSString *title = NSLocalizedString(@"Сегодня", @"");
    [self.calendarBtn setTitle:title forState:UIControlStateNormal];
    
    self.workdays = [NSMutableArray new];
    [self.workdays removeAllObjects];
    [[ApiManager new] getAllWorkdaysCompletition:^(id response, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            for (NSDictionary*dict in response){
                Workday *wd = [[Workday alloc] initWithDict:dict];
                [self.workdays addObject:wd];
                //[[ApiManager new] deleteWorkday:wd.id completition:^(id response, NSError *error) {}];
            }
            [self calendarSelectDate:[NSDate date]];
        });
    }];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (void)setupHours:(NSArray*)availibleTimes
{
    if (!self.buttons)self.buttons = [[NSMutableArray alloc] init];
    for (UIButton *btn in self.buttons)
        [btn removeFromSuperview];
    [self.buttons removeAllObjects];
    for (NSInteger i=0; i<14; i++)
    {
        NSString *time = [NSString stringWithFormat:@"%ld:00 - %ld:00",i+8,i+9];
        BOOL busy = [self busy:i+8];
        CGFloat offsetX = 25;
        if (i>6) offsetX = self.view.frame.size.width/2+10+20;
        CGFloat offsetY = 50+i*30;
        if (i>6)offsetY = 50+(i-7)*30;
        UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(offsetX, offsetY, self.view.frame.size.width/2-10, 30)];
        [btn setTitle:time forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateSelected];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        btn.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn setSelected:busy];
        btn.tag = i+8;
        btn.userInteractionEnabled = NO;
        [self.view addSubview:btn];
        [self.buttons addObject:btn];
    }
    [SVProgressHUD dismiss];
}

- (void)changeStatus:(UIButton*)btn{
    btn.selected = !btn.selected;
    Workhour *hour = nil;
    for (Workhour *wh in self.selectedWorkday.workhours){
        if (wh.hour.integerValue==btn.tag){
            hour = wh;
            break;
        }
    }
    if (hour){
        [[ApiManager new] updateWorkhour:hour.id params:@{@"busy":[NSNumber numberWithBool:btn.selected]} completition:^(id response, NSError *error) {
            
        }];
    }
    else [self addWorkhourWithIndex:btn.tag busy:[NSNumber numberWithBool:btn.selected]];
}

- (NSInteger)timeOffset{
    NSDate *sourceDate = [NSDate dateWithTimeIntervalSinceNow:3600 * 24 * 60];
    NSTimeZone* destinationTimeZone = [NSTimeZone systemTimeZone];
    NSInteger timeZoneOffset = [destinationTimeZone secondsFromGMTForDate:sourceDate] / 3600.0;
    return timeZoneOffset;
}

- (BOOL)busy:(NSInteger)hour{
    BOOL busy = NO;
    for (Workhour *wh in self.selectedWorkday.workhours){
        if (wh.hour.integerValue==hour){
            busy = wh.busy;
            break;
        }
    }
    return busy;
}

- (IBAction)showCalendar:(id)sender
{
    if (!self.calendar)
    {
        self.calendar = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"Calendar"];
    }
    self.calendar.delegate = self;
    self.calendar.view.alpha = 0.0;
    [[AppDelegate sharedDelegate].window addSubview:self.calendar.view];
    [UIView animateWithDuration:0.33 animations:^{
        self.calendar.view.alpha = 1.0;
    }];
}

- (void)calendarSelectDate:(NSDate *)date{
    [SVProgressHUD show];
    self.selectedWorkday = nil;
    BOOL today = [[NSCalendar currentCalendar] isDateInToday:date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EE, MMM d"];
    NSString *title = (today)?NSLocalizedString(@"Сегодня", @""):[formatter stringFromDate:date];
    [self.calendarBtn setTitle:title forState:UIControlStateNormal];
    [self getTimesForDate:date];
}

- (void)getTimesForDate:(NSDate*)date
{
    NSString *formattedDate = [date stringWithFormat:@"yyyy-MM-dd"];
    for (Workday *wd in self.workdays){
        if ([wd.date hasPrefix:formattedDate]){
            self.selectedWorkday = wd;
            [self getWorkhoursForWorkDay:self.selectedWorkday];
            break;
        }
    }
    
    if (!self.selectedWorkday){
        [[ApiManager new] createWorkday:[date stringWithFormat:@"yyyy-MM-dd"] completition:^(id response, NSError *error) {
            self.selectedWorkday = [[Workday alloc] initWithDict:response];
            [self.workdays addObject:self.selectedWorkday];
            [self getWorkhoursForWorkDay:self.selectedWorkday];
        }];
    }
}

- (void)addWorkhourWithIndex:(NSInteger)index busy:(NSNumber*)busy{
    index = index-4;
    NSDate *date = [self.selectedWorkday.date dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    date = [date dateByAddingTimeInterval:index*3600];
    NSString *ds = [date stringWithFormat:@"yyyy-MM-dd HH:mm:ss"];
    [[ApiManager new] createWorkhour:@{@"workday":self.selectedWorkday.id,@"hour":ds,@"busy":busy} completition:^(id response, NSError *error) {
        NSLog(@"%@",response);
    }];
}

- (void)getWorkhoursForWorkDay:(Workday*)workday{
    [[ApiManager new] getWorkDay:workday.id completition:^(id response, NSError *error) {
        self.selectedWorkday = [[Workday alloc] initWithDict:response];
        [self setupHours:nil];
    }];
}


- (void)hideCalendar:(BOOL)update
{
    [UIView animateWithDuration:0.33 animations:^{
        self.calendar.view.alpha = 0.0;
    } completion:^(BOOL finished) {
        if (update)[self calendarSelectDate:self.calendar.selectedDate];
        [self.calendar.view removeFromSuperview];
    }];
}

@end
