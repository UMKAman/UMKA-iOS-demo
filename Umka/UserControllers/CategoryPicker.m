//
//  CategoryPicker.m
//  Umka
//
//  Created by Igor Zalisky on 12/23/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "CategoryPicker.h"
#import "CategoryModel.h"
#import "FilterManager.h"
#import "ApiManager.h"

@interface CategoryPicker ()
@end

@implementation CategoryPicker

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
        self.allCategories = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in jsonObject)
        {
            CategoryModel *model = [[CategoryModel alloc] initWithDictionary:dict];
            if (!model.parent)[self.categories addObject:model];
            [self.allCategories addObject:model];
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

- (NSMutableArray*)getServicesForSection:(CategoryModel*)section
{
    NSMutableArray *ta = [[NSMutableArray alloc] init];
    for (CategoryModel *model in self.allCategories){
        if (model.parent.id.integerValue==section.id.integerValue)[ta addObject:model];
    }
    return ta;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CategoryModel *model = self.categories[indexPath.row];
    if (model.child.count>0){
        CategoryPicker *picker = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryPicker"];
        picker.categories = [self getServicesForSection:model];
        picker.allCategories = self.allCategories;
        picker.delegate = self.delegate;
        self.master = self.master;
        [self.navigationController pushViewController:picker animated:YES];
    }
    else [self.delegate categoryPicker:self didChooseCategory:model];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}



@end
