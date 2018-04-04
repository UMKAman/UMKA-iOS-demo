//
//  AccountSpecializations.m
//  Umka
//
//  Created by Ігор on 24.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountCategories.h"
#import "UserProfileCell.h"
#import "CategoryPicker.h"
#import "AccountCategoryCell.h"

@interface AccountCategories ()<CategoryPickerDelegate>
@property (nonatomic, strong) NSMutableArray *allCategories;
@end

@implementation AccountCategories

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self loadAllCategories];
}

-(void)loadAllCategories{
    [[ApiManager new] getCategoriesCompletition:^(NSArray *jsonObject, NSError *error) {
        self.allCategories = [NSMutableArray new];
        for (NSDictionary *dict in jsonObject){
            CategoryModel *model = [[CategoryModel alloc] initWithDictionary:dict];
            [self.allCategories addObject:model];
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.allCategories.count>0)?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.master.specializations.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==self.master.specializations.count)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"new_category"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"new_category"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
        cell.textLabel.text = NSLocalizedString(@"Добавить категорию", @"");
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:116.0/255.0 blue:193.0/255.0 alpha:1.0];
        return cell;
    }
    else{
        AccountCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"category"];
        if (!cell) {
            cell = [[AccountCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"category"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.categories = self.allCategories;
        cell.category = self.master.specializations[indexPath.row];
        cell.delegate = self;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row==self.master.specializations.count)?44:50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.master.specializations.count){
    CategoryPicker *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryPicker"];
    controller.master = self.master;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row==self.master.specializations.count)?NO:YES    ;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        CategoryModel *category = self.master.specializations[indexPath.row];
        [[ApiManager new] delSpecialization:category.id forMaster:[UmkaUser masterID] completition:^(id response, NSError *error) {
            NSMutableArray *specs = [self.master.specializations mutableCopy];
            [specs removeObject:category];
            self.master.specializations = specs;
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];

    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)removeCategory:(CategoryModel*)category{
    NSInteger index = [self.master.specializations indexOfObject:category];
    [[ApiManager new] delSpecialization:category.id forMaster:[UmkaUser masterID] completition:^(id response, NSError *error) {
        NSMutableArray *specs = [self.master.specializations mutableCopy];
        [specs removeObject:category];
        self.master.specializations = specs;
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

- (void)categoryPicker:(CategoryPicker *)cate didChooseCategory:(CategoryModel *)category{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Умка", @"")
                                          message:[NSString stringWithFormat:@"%@ - \"%@\"",NSLocalizedString(@"Добавить специальность",@""),category.name]
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *cancelAction = [UIAlertAction
                                   actionWithTitle:NSLocalizedString(@"Отмена", @"")
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction *action)
                                   {
                                       
                                   }];
    [alertController addAction:cancelAction];
    UIAlertAction *addAction = [UIAlertAction
                                actionWithTitle:NSLocalizedString(@"Добавить", @"")
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction *action){
                                    [cate.navigationController popToRootViewControllerAnimated:YES];
                                    [self addNewSpec:category];
                                }];
    [alertController addAction:addAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)addNewSpec:(CategoryModel*)category
{
    [[ApiManager new] addSpecialization:category.id forMaster:[UmkaUser masterID] completition:^(id response, NSError *error) {
        NSMutableArray *specs = [self.master.specializations mutableCopy];
        [specs addObject:category];
        self.master.specializations = specs;
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.master.specializations.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    }];
}

@end
