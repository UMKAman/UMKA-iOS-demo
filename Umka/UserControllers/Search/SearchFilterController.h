//
//  SearchFilterController.h
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFilterController : UITableViewController
@property (nonatomic,strong) NSMutableDictionary *filterSettings;
- (void)updateFilterData;
- (void)acceptFilter;
- (void)resetFilter;
@end
