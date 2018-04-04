//
//  UserNotificationsController.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserNotificationsController.h"
#import "UserNotificationsCell.h"
#import "UserNotificationsModel.h"
#import "UserChatController.h"

@interface UserNotificationsController ()
@property (nonatomic, strong) NSMutableArray *notificationsArray;
@end

@implementation UserNotificationsController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Уведомления",@"");
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];
    
    self.notificationsArray = [[NSMutableArray alloc] init];
    [self.notificationsArray removeAllObjects];
    
    NSArray *responseArray = @[];
    for (NSDictionary *dict in responseArray)
    {
        UserNotificationsModel *model = [[UserNotificationsModel alloc] initWithDictionary:dict];
        [self.notificationsArray addObject:model];
    }
    [self.tableView reloadData];
}

- (void)getLatestLoans
{
    [self performSelector:@selector(refreshInfo) withObject:nil afterDelay:2.0];
}

- (void)refreshInfo
{
    [self.refreshControl endRefreshing];
    self.notificationsArray = [[NSMutableArray alloc] init];
    [self.notificationsArray removeAllObjects];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (self.notificationsArray.count>0)?self.notificationsArray.count:1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.notificationsArray==nil)
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
    else if (self.notificationsArray.count>0)
    {
        UserNotificationsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserNotificationsCell"];
        if (!cell) {
            cell = [[UserNotificationsCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:@"UserNotificationsCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = self.notificationsArray[indexPath.row];
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
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.notificationsArray.count==0 || !self.notificationsArray)
        return [UIScreen mainScreen].bounds.size.height-64-49;
    else return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.notificationsArray.count>0)
    {
        UserChatController *ucc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserChatController"];
        [self.navigationController pushViewController:ucc animated:YES];
    }
}

@end
