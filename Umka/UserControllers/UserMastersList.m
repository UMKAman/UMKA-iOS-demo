//
//  UserMastersList.m
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserMastersList.h"
#import "CategoryModel.h"
#import "ApiManager.h"
#import "MasterModel.h"
#import "MasterCell.h"
#import "MasterProfileController.h"
#import "AccountPreviewController.h"

@interface UserMastersList ()
@property (nonatomic, strong) NSMutableArray *masters;
@end

@implementation UserMastersList

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    self.title = self.model.name;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 220;
    [self loadMastersList];
}

- (void)loadMastersList{
    NSString *page = @"1";
    if (self.masters.count>0)page = [NSString stringWithFormat:@"%ld",self.masters.count/10+1];
    [[ApiManager new] getMastersList:self.model.id completition:^(NSArray *jsonObjects, NSError *error) {
        self.masters = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in jsonObjects)
        {
            MasterModel *master = [[MasterModel alloc] initWithDictionary:dict];
            [self.masters addObject:master];
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
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return (self.masters.count>0)?self.masters.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.masters==nil)
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
    else if (self.masters.count>0)
    {
        MasterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterCell"];
        if (!cell) {
            cell = [[MasterCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"MasterCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.model = self.masters[indexPath.row];
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
        cell.textLabel.text = NSLocalizedString(@"Нет доступных мастеров",@"");
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.masters.count>0)
    {
        //MasterProfileController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"MasterProfileController"];
        AccountPreviewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPreviewController"];
        controller.master = self.masters[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


@end
