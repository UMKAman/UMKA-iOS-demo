//
//  MainMasterController.m
//  Umka
//
//  Created by Igor Zalisky on 12/23/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "MainMasterController.h"
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
#import "CategoryPicker.h"
#import "EditAboutTextController.h"
#import "EditUserController.h"
#import "CreateService.h"


@interface MainMasterController ()
@property(nonatomic, strong) NSDateFormatter *dateFormatter;
@property(nonatomic, strong) NSDate *minimumDate;
@property(nonatomic, strong) NSArray *disabledDates;
@property(nonatomic, strong) UILabel *dateLabel;
@property(nonatomic, strong) UILabel *aboutLabel;
@property(nonatomic, assign) CGFloat aboutCellHeight;
@end

@implementation MainMasterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Профиль",@"");
    [self.tableView reloadData];
    self.navigationController.navigationBarHidden = NO;
    self.aboutCellHeight = self.master.aboutHeight+60;
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
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
    [self updateScreenInfo];
    
    //[self setEditing:YES animated:YES];
}

- (void)updateScreenInfo
{
    [[ApiManager new] viewMasterProfile:[NSString stringWithFormat:@"%ld",[UmkaUser masterID]] completition:^(id response, NSError *error) {
        NSLog(@"%@", response);
        self.master = [[MasterModel alloc] initWithDictionary:response];
        [self.tableView reloadData];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self updateScreenInfo];
}

- (IBAction)menuButton:(UIButton *)sender {
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)editProfile:(id)sender
{
    EditUserController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditUserController"];
    controller.user = self.master.user;
    [self.navigationController pushViewController:controller animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section==0) return 1;
    else if (section==1) return 1;
    else if (section==2) return self.master.specializations.count+1;
    else if (section==3) return self.master.services.count+1;
    else if (section==4) return 1;
    else return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0)
    {
        UserProfileCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserProfileCell"];
        if (!cell) {
            cell = [[UserProfileCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"UserProfileCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        //[cell updateInfo];
        cell.user = self.master.user;
        return cell;
    }
    else if (indexPath.section==1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutTextCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:@"AboutTextCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!self.aboutLabel)self.aboutLabel = [cell.contentView viewWithTag:98];
        if (self.master.user.about.length>0)
        {
            self.aboutLabel.textColor = [UIColor blackColor];
            self.aboutLabel.textAlignment = NSTextAlignmentLeft;
            self.aboutLabel.text = self.master.user.about;
        }
        else
        {
            self.aboutLabel.textColor = [UIColor lightGrayColor];
            self.aboutLabel.textAlignment = NSTextAlignmentCenter;
            self.aboutLabel.text = NSLocalizedString(@"О себе",@"");
        }
        

        return cell;
    }
    else if (indexPath.section==2)
    {
        if (indexPath.row==self.master.specializations.count)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddServiceCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"AddServiceCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"Добавить новую категорию",@"");
            return cell;
        }
        else
        {
            CategoryModel *spec = self.master.specializations[indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ServiceCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"ServiceCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = spec.name;
            return cell;
        }
    }
    else if (indexPath.section==3)
    {
        if (indexPath.row==self.master.services.count)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AddPriceCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"AddPriceCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = NSLocalizedString(@"Добавить цену на услугу",@"");
            return cell;
        }
        else
        {
            Service *service = self.master.services[indexPath.row];
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PriceCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                              reuseIdentifier:@"PriceCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = [NSString stringWithFormat:@"%@",service.name];
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@/ %@ %@",service.cost,service.currency,service.count,service.measure];
            return cell;
        }
    }
    else if (indexPath.section==4)
    {
        PortfolioCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PortfolioCell"];
        if (!cell) {
            cell = [[PortfolioCell alloc] initWithStyle:UITableViewCellStyleDefault
                                        reuseIdentifier:@"PortfolioCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.editMode = YES;
        cell.master = self.master;
        return cell;
    }
    else
    {
        CalendarCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CalendarCell"];
        if (!cell) {
            cell = [[CalendarCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"CalendarCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.master = self.master;
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0) return 240.0;
    else if (indexPath.section==1) return (self.master.aboutHeight+20>55.0)?self.master.aboutHeight+20:55.0;
    else if (indexPath.section==2) return 44;
    else if (indexPath.section==3) return 44;
    else if (indexPath.section==4) return 120;
    else return 265.0;
}

- (void)reloadAboutCell:(CGFloat)height
{
    self.aboutCellHeight = height;
    [self.tableView reloadData];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        EditAboutTextController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"EditAboutTextController"];
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.section==2 && indexPath.row==self.master.specializations.count)
    {
        CategoryPicker *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryPicker"];
        controller.master = self.master;
        [self.navigationController pushViewController:controller animated:YES];
    }
    else if (indexPath.section==3 && indexPath.row==self.master.services.count)
    {
        CreateService *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"CreateService"];
        controller.master = self.master;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) return nil;
    else if (section==1) return NSLocalizedString(@"О себе",@"");
    else if (section==2) return NSLocalizedString(@"Специализации",@"");
    else if (section==3) return NSLocalizedString(@"Цены",@"");
    else if (section==4) return NSLocalizedString(@"Портфолио",@"");
    else return NSLocalizedString(@"График работы",@"");
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];

    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, tableView.frame.size.width, 18)];
    [label setFont:[UIFont boldSystemFontOfSize:16]];
    NSString *string = nil;
    if (section==0) string = nil;
    else if (section==1) string = NSLocalizedString(@"О себе",@"");
    else if (section==2) string = NSLocalizedString(@"Специализации",@"");
    else if (section==3) string =  NSLocalizedString(@"Цены",@"");
    else if (section==4) string =  NSLocalizedString(@"Портфолио",@"");
    else string = NSLocalizedString(@"График работы",@"");
    [label setText:string];
    label.textColor = [UIColor whiteColor];
    [view addSubview:label];
    [view setBackgroundColor:self.navigationController.navigationBar.barTintColor];
    return view;
}

- (void)removeCategory:(NSInteger)row
{
    NSInteger id_ = [self.master.services[row][@"id"] integerValue];
    [[ApiManager new] removeCategory:@{@"id":[NSString stringWithFormat:@"%ld",id_]} completition:^(id response, NSError *error) {
        [self updateScreenInfo];
    }];
}

- (void)removePrice:(NSInteger)row
{
    Service *service = self.master.services[row];
    [[ApiManager new] delService:service.id completition:^(id response, NSError *error) {
        [self updateScreenInfo];
    }];
}


- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0)return NO;
    else if (indexPath.section==1)return NO;
    else if (indexPath.section==2)
    {
        if (indexPath.row==self.master.specializations.count)return YES;
        else return YES;
    }
    else if (indexPath.section==3)
    {
        if (indexPath.row==self.master.services.count)return YES;
        else return YES;
    }
    else if (indexPath.section==4)return NO;
    else return NO;
}

// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        if (indexPath.section==2)
        {
            [self removeCategory:indexPath.row];
        }
        else if (indexPath.section==3)
        {
            [self removePrice:indexPath.row];
        }
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
}



#pragma mark -

@end
