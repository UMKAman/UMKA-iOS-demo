//
//  AMMenuTableViewController.h
//  AdWithMe
//
//  Created by Eugene Kuropatenko on 21.11.15.
//  Copyright © 2015 AdWithMe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LeftMenuTable : UITableViewController
@property (strong, nonatomic) UIColor *tintColor;
- (void)reloadMainMenu;
- (void)selectRootController;
- (void)viewProfile;
@end
