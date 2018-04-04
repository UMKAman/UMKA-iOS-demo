//
//  AdWithMeTopTableViewController.h
//  AdWithMe
//
//  Created by Igor Zaliskyj on 4/2/16.
//  Copyright © 2016 AdWithMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UmkaTopTableViewController : UITableViewController
@property (strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) UIButton *searchBtn;
- (IBAction)menuButton:(UIButton *)sender;
@end
