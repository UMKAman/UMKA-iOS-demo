//
//  UserProfileController.m
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserProfileController.h"
#import "UserProfileCell.h"
#import "UserModel.h"
#import "EditUserController.h"

@interface UserProfileController ()

@end

@implementation UserProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Профиль",@"");
    [self.tableView reloadData];
    self.navigationController.navigationBarHidden = NO;
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 30, 44)];
    [editBtn setImage:[UIImage imageNamed:@"ic_navbar_edit"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(editProfile:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Профиль",@"");
    [self.tableView reloadData];
}

- (void)editProfile:(id)sender
{
    EditUserController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditUserController"];
    controller.user = self.user;
    [self.navigationController pushViewController:controller animated:YES];
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
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileCell"];
    if (!cell) {
        cell = [[UserProfileCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"UserProfileCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    cell.user = self.user;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 240;
}

@end
