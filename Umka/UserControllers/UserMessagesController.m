//
//  UserNotificationsController.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserMessagesController.h"
#import "UserMessagesCell.h"
#import "UserNotificationsModel.h"
#import "UserChatController.h"

@interface UserMessagesController ()
@property (nonatomic, strong) NSMutableArray *dialogs;
@end

@implementation UserMessagesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Сообщения",@"");
    self.navigationItem.rightBarButtonItem = nil;
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.dialogs = [NSMutableArray new];
    [self.dialogs removeAllObjects];
    [[ApiManager new] getDialogsCompletition:^(NSArray *object, NSError *error) {
        if (object){
            for (NSDictionary *dict in object){
                Dialog *model = [[Dialog alloc] initWithDictionary:dict];
                [self.dialogs addObject:model];
            }
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
    self.dialogs = [[NSMutableArray alloc] init];
    [self.dialogs removeAllObjects];
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
    return (self.dialogs.count>0)?self.dialogs.count:1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.dialogs==nil)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"LoadingCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.text = @"Загрузка...";
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor lightGrayColor];
        return cell;
    }
    else if (self.dialogs.count>0)
    {
        UserMessagesCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserMessagesCell"];
        if (!cell) {
            cell = [[UserMessagesCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:@"UserMessagesCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = self.dialogs[indexPath.row];
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
        label.text = NSLocalizedString(@"Еще нет сообщений", @"");
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dialogs.count==0 || !self.dialogs)
        return [UIScreen mainScreen].bounds.size.height-64-49;
    else return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.dialogs.count>0)
    {
        Dialog *model = self.dialogs[indexPath.row];
        UserChatController *ucc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserChatController"];
        ucc.dialog = model;
        [self.navigationController pushViewController:ucc animated:YES];
    }
}

- (void)openChatWithChatID:(NSNumber*)chatID{
    Dialog *model = [Dialog new];
    model.id = chatID;
    UserChatController *ucc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserChatController"];
    ucc.dialog = model;
    [self.navigationController pushViewController:ucc animated:YES];
}

@end
