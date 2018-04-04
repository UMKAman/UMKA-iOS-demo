//
//  AccountPortfolio.m
//  Umka
//
//  Created by Ігор on 24.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountPortfolio.h"
#import "AccountPortfolioCell.h"
#import "CreatePortfolio.h"
@interface AccountPortfolio ()<CreatePortfolioDelegate>

@end

@implementation AccountPortfolio

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
    return self.master.portfolios.count+1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row==self.master.portfolios.count)?44:140;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==self.master.portfolios.count)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"add_portfolio"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"add_portfolio"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
        cell.textLabel.text = NSLocalizedString(@"Добавить работу",@"");
        cell.textLabel.textColor = [UIColor colorWithRed:0 green:116.0/255.0 blue:193.0/255.0 alpha:1.0];
        return cell;
    }
    else
    {
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
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.master.portfolios.count){
        CreatePortfolio *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePortfolio"];
        controller.master = self.master;
        controller.delegate = self;
        controller.editingMode = YES;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else [self editPortfolio:indexPath];
}

- (void)portfolioDidCreated:(Portfolio *)portfolio{
    NSMutableArray *portfolios = [self.master.portfolios mutableCopy];
    [portfolios addObject:portfolio];
    self.master.portfolios = portfolios;
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.master.portfolios.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadData];
}

- (void)portfolioDidChanged:(Portfolio *)portfolio{
    NSMutableArray *portfolios = [self.master.portfolios mutableCopy];
    NSInteger index = 999;
    for (Portfolio *pf in portfolios){
        if (pf.id.integerValue==portfolio.id.integerValue){
            index = [portfolios indexOfObject:pf];
        }
    }
    if (index!=999){
         [portfolios replaceObjectAtIndex:index withObject:portfolio];
        self.master.portfolios = portfolios;
    }
    else {
        [portfolios addObject:portfolio];
        self.master.portfolios = portfolios;
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.master.portfolios.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }
}

- (void)removePortfolio:(NSIndexPath*)indexPath
{
    Portfolio *portfolio = self.master.portfolios[indexPath.row];
    [[ApiManager new] delPortfolio:portfolio.id completition:^(id response, NSError *error) {
        NSMutableArray *portfolios = [self.master.portfolios mutableCopy];
        [portfolios removeObject:portfolio];
        self.master.portfolios = portfolios;
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView reloadData];
    }];
}

- (void)editPortfolio:(NSIndexPath*)indexPath{
    CreatePortfolio *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePortfolio"];
    controller.portfolio = self.master.portfolios[indexPath.row];
    controller.delegate = self;
    controller.editingMode = YES;
    [self.navigationController pushViewController:controller animated:YES];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row==self.master.portfolios.count)? NO:YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self removePortfolio:indexPath];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)setEditingMode:(BOOL)editingMode{
    [self setEditing:editingMode animated:YES];
}

@end
