//
//  UmkaCallendar.h
//  Umka
//
//  Created by Igor Zalisky on 12/20/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CalendarDelegate;

@interface UmkaCallendar : UIViewController
@property (nonatomic, strong) NSDate *selectedDate;
@property (nonatomic, weak) id<CalendarDelegate> delegate;
@end

@protocol CalendarDelegate <NSObject>
- (void)calendarSelectDate:(NSDate*)date;
- (void)hideCalendar:(BOOL)update;
@end
