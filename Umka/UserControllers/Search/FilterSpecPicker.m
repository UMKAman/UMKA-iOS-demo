//
//  FilterSpecPicker.m
//  Umka
//
//  Created by Igor Zalisky on 12/7/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "FilterSpecPicker.h"
#import "ApiManager.h"
#import "CategoryModel.h"
#import "SearchFilterController.h"
#import "FilterManager.h"
#import "CreateService.h"

@interface FilterSpecPicker ()

@end

@implementation FilterSpecPicker

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = NSLocalizedString(@"Специализация",@"");
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    
    if (!self.categories) [self loadCategories];
}

- (void)loadCategories
{
    [[ApiManager new] getCategoriesCompletition:^(NSArray *jsonObject, NSError *error) {
        self.categories = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in jsonObject)
        {
            CategoryModel *model = [[CategoryModel alloc] initWithDictionary:dict];
            if (!model.parent)[self.categories addObject:model];
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.categories.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"FilterCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    CategoryModel *model = self.categories[indexPath.row];
    cell.textLabel.text = model.name;
    return cell;
}

- (NSMutableArray*)parseChilds:(NSArray*)childs{
    NSMutableArray *ta = [NSMutableArray new];
    for (NSDictionary *dict in childs)
    {
        CategoryModel *model = [[CategoryModel alloc] initWithDictionary:dict];
        [ta addObject:model];
    }
    return ta;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    CategoryModel *model = self.categories[indexPath.row];
    if (model.child.count>0)
    {
        FilterSpecPicker *picker = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterSpecPicker"];
        picker.categories = [self parseChilds:model.child];
        picker.delegate = self.delegate;
        [self.navigationController pushViewController:picker animated:YES];
    }
    else
    {
        if ([self.delegate isKindOfClass:[SearchFilterController class]])
        {
        [FilterManager saveSpec:self.categories[indexPath.row]];
        [[self delegate] updateFilterData];
        [self.navigationController popToRootViewControllerAnimated:YES];
        }
        else
        {
            [[self delegate] selectCategory:self.categories[indexPath.row]];
            [self.navigationController popToViewController:self.delegate animated:YES];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

@end
