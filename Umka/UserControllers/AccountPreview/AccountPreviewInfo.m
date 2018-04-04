//
//  AccountPreviewInfo.m
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountPreviewInfo.h"
#import "AccountController.h"
#import "AccountInfoCell.h"

@interface AccountPreviewInfo ()

@end

@implementation AccountPreviewInfo

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.estimatedRowHeight = 140;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
}

- (void)setEditingMode:(BOOL)editingMode
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView*)tableView heightForFooterInSection:(NSInteger)section {
    return 0.001f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section==0)return 13*SCALE_COOF;
    else return 34*SCALE_COOF;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0)return self.user?2:5;
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section==1 || section==2)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 34*SCALE_COOF)];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 9*SCALE_COOF, tableView.frame.size.width, 25*SCALE_COOF)];
        [label setFont:[UIFont fontWithName:@"HelveticaNeue" size:13*SCALE_COOF]];
        NSString *string = (section==1)?NSLocalizedString(@"О СЕБЕ",@""):@"";
        label.textColor = [UIColor colorWithWhite:0.3 alpha:1.0];
        [label setText:string];
        [view addSubview:label];
        [view setBackgroundColor:[UIColor clearColor]]; //your background color...
        return view;
    }
    else return nil;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *s = (indexPath.section==1)?@"AboutCell":(indexPath.row==0)?@"InfoCell":(indexPath.row==1)?@"gender":(indexPath.row==2)?@"switch1":(indexPath.row==3)?@"switch2":@"address";
    AccountInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:s];
    if (!cell) {
        cell = [[AccountInfoCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:s];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    cell.delegate = self;
    if (self.user)cell.user = self.user;
    else cell.master = self.master;
    return cell;
}


@end
