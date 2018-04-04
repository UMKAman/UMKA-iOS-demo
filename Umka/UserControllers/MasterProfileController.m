//
//  MasterProfileController.m
//  Umka
//
//  Created by Igor Zalisky on 12/19/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "MasterProfileController.h"
#import "MasterCell.h"
#import "CalendarCell.h"
#import "PortfolioCell.h"
#import "AboutCell.h"
#import "MasterModel.h"
#import "LeftMenuController.h"
#import "AppDelegate.h"
#import "EditMasterProfile.h"
#import "UserProfileCell.h"
#import "ApiManager.h"
#import "UmkaUser.h"


@interface MasterProfileController ()
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, assign) CGFloat aboutCellHeight;
@property(nonatomic, assign) BOOL is_self;
@end

@implementation MasterProfileController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Профиль",@"");
    [self.tableView reloadData];
    self.navigationController.navigationBarHidden = NO;
    self.aboutCellHeight = self.model.aboutHeight+60;
    
    if (!self.model)
    {
        self.is_self = YES;
        UIButton* menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 44, 44)];
        [menuBtn setImage:[UIImage imageNamed:@"ic_navbar_side_menu"] forState:UIControlStateNormal];
        [menuBtn addTarget:self action:@selector(menuButton:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:menuBtn];
        self.navigationItem.leftBarButtonItem = barItem;
        
        UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 30, 44)];
        [editBtn setImage:[UIImage imageNamed:@"ic_navbar_edit"] forState:UIControlStateNormal];
        [editBtn addTarget:self action:@selector(editProfile:) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *barItem1 = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
        self.navigationItem.rightBarButtonItem = barItem1;
        
        [[ApiManager new] viewProfile:[NSString stringWithFormat:@"%ld",[UmkaUser profile]] completition:^(id response, NSError *error) {
            NSLog(@"%@", response);
            self.model = [[MasterModel alloc] initWithDictionary:response];
            [self.tableView reloadData];
        }];
    }
}

- (IBAction)menuButton:(UIButton *)sender {
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)editProfile:(id)sender
{
    EditMasterProfile *emp = [self.storyboard instantiateViewControllerWithIdentifier:@"EditMasterProfile"];
    [self.navigationController pushViewController:emp animated:YES];
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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==0)
    {
        if (self.is_self)
        {
            UserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileCell"];
            if (!cell) {
                cell = [[UserProfileCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"UserProfileCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            //[cell updateInfo];
           // else cell.user = self.user;
            return cell;
        }
        else
        {
            MasterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterCell"];
            if (!cell) {
                cell = [[MasterCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"MasterCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            cell.model = self.model;
            return cell;
        }
        
    }
    else if (indexPath.row==1)
    {
        PortfolioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PortfolioCell"];
        if (!cell) {
            cell = [[PortfolioCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"PortfolioCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.master = self.model;
        return cell;
    }
    else if (indexPath.row==2)
    {
        CalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarCell"];
        if (!cell) {
            cell = [[CalendarCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"CalendarCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.master = self.model;
        return cell;
    }
    else
    {
        AboutCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutCell"];
        if (!cell) {
            cell = [[AboutCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"AboutCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.master = self.model;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0) return 240.0;
    else if (indexPath.row==1)
    {
        CGFloat ch = 250;
        if (self.model.services.count>2)ch =  250.0;
        else if (self.model.services.count==2)ch =  220.0;
        else if (self.model.services.count==1)ch =  190.0;
        else if (self.model.services.count==0)ch =  160.0;
        if (self.model.portfolios.count==0)ch = ch-120;
        return ch;
    }
    else if (indexPath.row==2) return 265.0;
    else return self.aboutCellHeight;
}

- (void)reloadAboutCell:(CGFloat)height
{
    self.aboutCellHeight = height;
    [self.tableView reloadData];
}


#pragma mark - 

@end
