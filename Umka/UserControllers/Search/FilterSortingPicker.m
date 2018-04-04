//
//  FilterSortingPicker.m
//  Umka
//
//  Created by Igor Zalisky on 12/7/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "FilterSortingPicker.h"
#import "Constants.h"
#import "SearchFilterController.h"
#import "FilterManager.h"


@interface FilterSortingPicker ()
@property (nonatomic, assign) NSInteger selectedOption;
@end

@implementation FilterSortingPicker

- (void)viewDidLoad {
    [super viewDidLoad];
    self.selectedOption = [FilterManager sortBy];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
self.title = NSLocalizedString(@"Сортировать по",@"");
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return K_FILTER_SORTING_ITEMS.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"FilterCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row==self.selectedOption)cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = K_FILTER_SORTING_ITEMS[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedOption = indexPath.row;
    [FilterManager saveSortBy:self.selectedOption];
    [[self delegate] updateFilterData];
    //[self.tableView reloadData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end