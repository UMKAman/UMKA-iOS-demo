//
//  ViewController.h
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGSideMenuController.h"
#import "LeftMenuTable.h"
@interface LeftMenuController : LGSideMenuController
@property (strong, nonatomic) LeftMenuTable *leftViewController;

@end

