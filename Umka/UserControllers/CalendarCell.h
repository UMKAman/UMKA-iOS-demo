//
//  CalendarCell.h
//  Umka
//
//  Created by Igor Zalisky on 12/19/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MasterModel;
@interface CalendarCell : UITableViewCell
@property (nonatomic, strong) MasterModel *master;
@property (nonatomic, weak) id delegate;
@property (nonatomic, weak) IBOutlet UIView *cellView;
@property (nonatomic, weak) IBOutlet UIButton *calendarBtn;
@property (nonatomic, strong) NSMutableArray *buttons;
- (void)updateDate:(NSDate*)date;
@end
