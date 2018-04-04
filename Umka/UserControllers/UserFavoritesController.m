//
//  UserFavoritesController.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserFavoritesController.h"
#import "UserFavouritesCell.h"
#import "MasterModel.h"
#import "Constants.h"
#import "MasterProfileController.h"
#import "AccountPreviewController.h"

@interface UserFavoritesController ()
@property (nonatomic, strong) NSMutableArray *favouritesArray;
@end

@implementation UserFavoritesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Избранное",@"");
     self.navigationItem.rightBarButtonItem = nil;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];
    [self loadMasters];
}

- (void)loadMasters{
    [[ApiManager new] getFavorites:[NSString stringWithFormat:@"%ld",[UmkaUser userID]]  completition:^(NSArray *object, NSError *error) {
        self.favouritesArray = [[NSMutableArray alloc] init];
        [self.favouritesArray removeAllObjects];
        for (NSDictionary *dict in object){
            MasterModel *model = [[MasterModel alloc] initWithDictionary:dict];
            model.isFav = YES;
            [self.favouritesArray addObject:model];
        }
        [self.tableView reloadData];
    }];
}

- (void)getLatestLoans
{
    [self performSelector:@selector(refreshInfo) withObject:nil afterDelay:2.0];
}

- (void)refreshInfo
{
    [self.refreshControl endRefreshing];
    self.favouritesArray = [[NSMutableArray alloc] init];
    [self.favouritesArray removeAllObjects];
    self.favouritesArray = nil;
    [self.tableView reloadData];
    [self loadMasters];
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
    return (self.favouritesArray.count>0)?self.favouritesArray.count:1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.favouritesArray==nil)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"LoadingCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        return cell;
    }
    else if (self.favouritesArray.count>0)
    {
        UserFavouritesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserFavouritesCell"];
        if (!cell) {
            cell = [[UserFavouritesCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"UserFavouritesCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = self.favouritesArray[indexPath.row];
        cell.delegate = self;
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
        UILabel *label = [cell.contentView viewWithTag:333];
        label.text = NSLocalizedString(@"Еще нет избранных специалистов", @"");
        
        UILabel *label1 = [cell.contentView viewWithTag:222];
        label1.text = NSLocalizedString(@"Чтобы добавить специалиста\nв этом списке нажмите на значок\nзвездочки в профиле", @"");
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.favouritesArray.count==0 || !self.favouritesArray)return [UIScreen mainScreen].bounds.size.height-64-49;
    else return 134;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.favouritesArray.count>0)
    {
        AccountPreviewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPreviewController"];
        controller.master = self.favouritesArray[indexPath.row];
        [self.navigationController pushViewController:controller animated:YES];
    }
}


- (void)delMaster:(MasterModel*)master{
    [[ApiManager new] delFavorite:[NSString stringWithFormat:@"%ld",[UmkaUser userID]] master_id:master.id completition:^(NSArray *object, NSError *error) {
        [self loadMasters];
    }];
}


@end
