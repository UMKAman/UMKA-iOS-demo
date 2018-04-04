//
//  UserOrdersHistory.m
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserOrdersHistory.h"
#import "UserOrderHistoryCell.h"
#import "UserOrderModel.h"
#import "Constants.h"
#import "SendReviewController.h"
#import "MasterProfileController.h"
#import "AccountPreviewController.h"

@interface UserOrdersHistory ()
@property (nonatomic, strong) NSMutableArray *orders;
@end

@implementation UserOrdersHistory

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"История заказов",@"");
     self.navigationItem.rightBarButtonItem = nil;
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];
    
    [self loadHistory];
}

- (void)loadHistory{
    
    NSString *appMode = [UmkaUser appMode];
    NSDictionary *params = ([appMode isEqualToString:@"user"])?@{@"where":@{@"user":[NSNumber numberWithInteger:[UmkaUser userID]]}}:@{@"where":@{@"master":[NSNumber numberWithInteger:[UmkaUser masterID]]}};
    
    [[ApiManager new] getOrders:params completition:^(NSArray *object, NSError *error) {
        self.orders = [[NSMutableArray alloc] init];
        [self.orders removeAllObjects];
        for (NSDictionary *dict in object){
            UserOrderModel *model = [[UserOrderModel alloc] initWithDictionary:dict];
            [self.orders addObject:model];
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
    self.orders = [[NSMutableArray alloc] init];
    [self.orders removeAllObjects];
    [self.tableView reloadData];
    [self loadHistory];
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
    return (self.orders.count>0)?self.orders.count:1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.orders==nil)
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
    else if (self.orders.count>0)
    {
        NSString *appMode = [UmkaUser appMode];
        NSString *identifier = ([appMode isEqualToString:@"user"])?@"UserOrderHistoryCell":@"master_order_cell";
        UserOrderHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UserOrderHistoryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:identifier];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = self.orders[indexPath.row];
        cell.delegate = self;
        cell.reviewBtn.tag = indexPath.row;
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
        label.text = NSLocalizedString(@"Еще нет сделок", @"");
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *appMode = [UmkaUser appMode];
    NSInteger height = ([appMode isEqualToString:@"user"])?134:75;
    if (self.orders.count==0 || !self.orders)return [UIScreen mainScreen].bounds.size.height-64-49;
    else return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (self.orders.count>0)
    {
        NSString *appMode = [UmkaUser appMode];
        UserOrderModel *order = self.orders[indexPath.row]; 
        AccountPreviewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPreviewController"];
        if ([appMode isEqualToString:@"master"])controller.user = order.user;
        else controller.master = order.master;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (void)sendReviewAction:(UserOrderModel*)order{
    SendReviewController *src = [self.storyboard instantiateViewControllerWithIdentifier:@"SendReviewController"];
    src.order = order;
    [self.navigationController pushViewController:src animated:YES];
}

@end
