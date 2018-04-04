//
//  UserServicesController.m
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserServicesController.h"
#import "CategoryModel.h"
#import "UmkaTabbarController.h"
#import "UserSpecController.h"
#import "UserMastersList.h"

@interface UserServicesController ()

@end

@implementation UserServicesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.title = self.sectionTitle;
    [self.navigationItem.backBarButtonItem setTitle:@" "];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return (self.services.count>0)?self.services.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.services==nil)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"LoadingCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = NSLocalizedString(@"Загрузка...",@"");
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        return cell;
    }
    else if (self.services.count>0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserServiceCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:@"UserServiceCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        CategoryModel *model = self.services[indexPath.row];
        cell.textLabel.text = model.name;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EmptyCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"EmptyCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.services.count==0 || !self.services)
        return [UIScreen mainScreen].bounds.size.height-64-49;
    else return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.services>0)
    {
    CategoryModel* model = [self.services objectAtIndex:indexPath.row];
    NSMutableArray *servicesArray = [self getServicesForSection:model];
    if (servicesArray.count>0){
        UserSpecController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSpecController"];
        tvc.services = servicesArray;
        tvc.sectionTitle = model.name;
        [self.navigationController pushViewController:tvc animated:YES];
    }
    else
    {
        UserMastersList *uml = [self.storyboard instantiateViewControllerWithIdentifier:@"UserMastersList"];
        uml.model = model;
        [self.navigationController pushViewController:uml animated:YES];
    }
    }
}

- (NSMutableArray*)getServicesForSection:(CategoryModel*)section
{
    NSMutableArray *ta = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.allCategories){
        CategoryModel *model = [[CategoryModel alloc] initWithDictionary:dict];
        if (model.parent.id.integerValue==section.id.integerValue)[ta addObject:model];
    }
    return ta;
}
@end
