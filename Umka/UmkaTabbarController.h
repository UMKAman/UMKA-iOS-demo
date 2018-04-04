//
//  UmkaTabbarController.h
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UmkaTabbarController : UITabBarController
@property (strong, nonatomic) UIButton *menuBtn;
- (IBAction)menuButton:(UIButton *)sender;
- (void)changeToBack;
- (void)changeToMenu;
@end
