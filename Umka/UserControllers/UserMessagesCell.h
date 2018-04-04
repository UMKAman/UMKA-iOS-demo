//
//  UserNotificationsCell.h
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface UserMessagesCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *message;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *count;
@property (nonatomic, weak) IBOutlet UIView *bluePoint;
@property (nonatomic, strong) Dialog *model;
@property (nonatomic, weak) id delegate;
@end
