//
//  AccountServices.m
//  Umka
//
//  Created by Ігор on 24.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountServices.h"
#import "CreateService.h"

@interface AccountServices ()<CreateServiceDelegate>

@end

@implementation AccountServices

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
    return self.master.services.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        if (indexPath.row==self.master.services.count)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"add_service"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"add_service"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.textAlignment = NSTextAlignmentLeft;
            cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:15];
            cell.textLabel.text = NSLocalizedString(@"Добавить услугу",@"");
            cell.textLabel.textColor = [UIColor colorWithRed:0 green:116.0/255.0 blue:193.0/255.0 alpha:1.0];
            return cell;
        }
        else
        {
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
            
            for (id subview in cell.contentView.subviews){
                if ([subview isKindOfClass:[UIButton class]]){
                    [subview setTag:indexPath.row];
                    [subview addTarget:self action:@selector(removeService:) forControlEvents:UIControlEventTouchUpInside];
                }
            }
            
            return cell;
        }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return (indexPath.row==self.master.services.count)?44:50;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row==self.master.services.count){
    CreateService *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateService"];
    controller.master = self.master;
    controller.delegate = self;
    [self.navigationController pushViewController:controller animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return (indexPath.row==self.master.services.count)? NO:YES;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Service *service = self.master.services[indexPath.row];
        [[ApiManager new] delService:service.id completition:^(id response, NSError *error) {
            NSMutableArray *services = [self.master.services mutableCopy];
            [services removeObject:service];
            self.master.services = services;
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        }];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}

- (void)setEditingMode:(BOOL)editingMode{
    [self setEditing:editingMode animated:YES];
}
                     
                     - (void)removeService:(UIButton*)btn{
                         Service *service = self.master.services[btn.tag];
                         [[ApiManager new] delService:service.id completition:^(id response, NSError *error) {
                             NSMutableArray *services = [self.master.services mutableCopy];
                             [services removeObject:service];
                             self.master.services = services;
                             [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:btn.tag inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                         }];
                     }

- (void)serviceDidCreated:(Service *)service{
    NSMutableArray *services = [self.master.services mutableCopy];
    [services addObject:service];
    self.master.services = services;
    [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.master.services.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

@end
