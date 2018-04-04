//
//  FilterSpecPicker.h
//  Umka
//
//  Created by Igor Zalisky on 12/7/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterSpecPicker : UITableViewController
@property (nonatomic, weak) id delegate;
@property (nonatomic, strong) NSMutableArray *categories;
@end
