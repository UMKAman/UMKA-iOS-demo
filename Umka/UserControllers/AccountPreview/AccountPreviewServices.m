//
//  AccountPreviewServices.m
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountPreviewServices.h"

@interface AccountPreviewServices ()

@end

@implementation AccountPreviewServices

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    return self.master.services.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.master.services>0){
        Service *service = self.master.services[indexPath.row];
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"service"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                          reuseIdentifier:@"service"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UILabel *textLabel = [cell.contentView viewWithTag:100];
        textLabel.text = [NSString stringWithFormat:@"%@",service.name];
        textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:15];
        
        UILabel *detailTextLabel = [cell.contentView viewWithTag:200];
        detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ %@/ %@ %@",NSLocalizedString(@"Стоимость",@""),service.cost,service.currency,service.count,service.measure];
        detailTextLabel.textColor = [UIColor darkGrayColor];
        detailTextLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:13];
        
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
