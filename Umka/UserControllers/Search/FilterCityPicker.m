//
//  FilterCityPicker.m
//  Umka
//
//  Created by Igor Zalisky on 12/7/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "FilterCityPicker.h"
#import "SearchFilterController.h"
#import "Constants.h"
#import "FilterManager.h"

@interface FilterCityPicker ()
@property (nonatomic, strong) NSMutableArray *cityArray;
@property (nonatomic, assign) NSInteger selectedCity;
@end

@implementation FilterCityPicker

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *city = [FilterManager city];
    //self.cityArray = [K_FILTER_CITIES_ITEMS mutableCopy];
    if ([self.cityArray containsObject:city]) self.selectedCity = [self.cityArray indexOfObject:city];
    else self.selectedCity = 0;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = NSLocalizedString(@"Город",@"");
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
    
    return self.cityArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"FilterCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if (indexPath.row==self.selectedCity)cell.accessoryType = UITableViewCellAccessoryCheckmark;
    else cell.accessoryType = UITableViewCellAccessoryNone;
    cell.textLabel.text = self.cityArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    self.selectedCity = indexPath.row;
    [FilterManager saveCity:self.cityArray[self.selectedCity]];
    [[self delegate] updateFilterData];
   // [self.tableView reloadData];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}


@end
