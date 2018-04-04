//
//  UserServicesController.h
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserServicesController : UITableViewController
@property (nonatomic,strong) NSMutableArray *services;
@property (nonatomic,strong) NSArray *allCategories;
@property (nonatomic,strong) NSString *sectionTitle;
@end
