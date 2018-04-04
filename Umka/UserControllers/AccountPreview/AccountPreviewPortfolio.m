//
//  AccountPreviewPortfolio.m
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountPreviewPortfolio.h"
#import "AccountPortfolioCell.h"

@interface AccountPreviewPortfolio ()

@end

@implementation AccountPreviewPortfolio

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    return self.master.portfolios.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 140;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Portfolio *portfolio = self.master.portfolios[indexPath.row];
    AccountPortfolioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"portfolio"];
    if (!cell) {
        cell = [[AccountPortfolioCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                           reuseIdentifier:@"portfolio"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.indexPath = indexPath;
    cell.delegate = self;
    cell.portfolio = portfolio;
    [cell reloadImages];
    return cell;
}


@end
