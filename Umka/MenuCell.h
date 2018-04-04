//
//  MenuCell.h
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel *menuTitle;
@property (nonatomic, weak) IBOutlet UILabel *menuSubTitle;
@property (nonatomic, weak) IBOutlet UIImageView *menuIcon;
@property (nonatomic, weak) IBOutlet UISwitch *modeSwitch;
@property (nonatomic, weak) id delegate;
@end
