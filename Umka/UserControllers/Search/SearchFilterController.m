//
//  SearchFilterController.m
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "SearchFilterController.h"
#import "MasterCell.h"
#import "FilterCell.h"
#import "FilterLabelCell.h"
#import "FilterSwitchCell.h"
#import "FilterPriceCell.h"

#import "FilterManager.h"
#import "FilterCityPicker.h"
#import "FilterSpecPicker.h"
#import "FilterGenderPicker.h"
#import "FilterSortingPicker.h"
#import "Constants.h"
#import "SelectLocationOnMap.h"
#import "CategoryPicker.h"
#import <objc/runtime.h>


@interface SearchFilterController ()<LocationPickerDelegate,CategoryPickerDelegate,UISearchBarDelegate>
@property (nonatomic, strong) UIButton *closeBtn;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) NSMutableArray *masters;
@property (nonatomic, assign) BOOL openFilter;
@property (nonatomic, assign) BOOL filterAccept;
@property (nonatomic, assign) CGFloat keyboardHeight;
@property (nonatomic, strong) FilterCell *filterCell;
@end

@implementation SearchFilterController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.filterSettings = [NSMutableDictionary new];
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(keyboardOnScreen:) name:UIKeyboardDidShowNotification object:nil];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.openFilter = NO;
    self.closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 80, 44)];
    self.closeBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    //[self.closeBtn setImage:[UIImage imageNamed:@"ic_navbar_side_menu"] forState:UIControlStateNormal];
    [self.closeBtn setTitle:NSLocalizedString(@"Закрыть",@"") forState:UIControlStateNormal];
    [self.closeBtn addTarget:self action:@selector(closeAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.closeBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width-90, 44)];
    self.navigationItem.titleView = self.searchBar;
    self.searchBar.delegate = self;
    [self.searchBar becomeFirstResponder];
    
    [self.navigationItem.backBarButtonItem setTitle:@" "];
    [self.navigationController.navigationItem.backBarButtonItem setTitle:@" "];
}

- (void)closeAction
{
     [self.searchBar resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section==0) return self.openFilter?9:1;
    else return (self.masters.count>0)?self.masters.count:1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            self.filterCell = [tableView dequeueReusableCellWithIdentifier:@"FilterCell"];
            if (!self.filterCell) {
                self.filterCell = [[FilterCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"FilterCell"];
                self.filterCell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            self.filterCell.delegate = self;
            self.filterCell.openFilter = self.openFilter;
            return self.filterCell;
        }
        else if (indexPath.row>0 && indexPath.row<5)
        {
            FilterLabelCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterLabelCell"];
            if (!cell) {
                cell = [[FilterLabelCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"FilterLabelCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.tag = indexPath.row;
            [cell reloadCell];
            return cell;
        }
        else if (indexPath.row>=5 && indexPath.row<8)
        {
            FilterSwitchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterSwitchCell"];
            if (!cell) {
                cell = [[FilterSwitchCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"FilterSwitchCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.optionSwitch.tag = indexPath.row;
            cell.titleLabel.text = K_FILTER_ITEMS[indexPath.row];
            [cell reloadCell];
            return cell;
        }
        else
        {
            FilterPriceCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FilterPriceCell"];
            if (!cell) {
                cell = [[FilterPriceCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"FilterPriceCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            return cell;
        }
    }
    else
    {
        if (self.masters==nil)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StartCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"StartCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor lightGrayColor];
            
            UILabel *lbl = [cell.contentView viewWithTag:111];
            lbl.text = NSLocalizedString(@"Введите категорию для поиска", @"");
            
            UILabel *lbl1 = [cell.contentView viewWithTag:222];
            lbl1.text = NSLocalizedString(@"Например: дизайн, ремонт, перевозка", @"");
            
            return cell;
        }
        else if (self.masters.count>0)
        {
            MasterCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MasterCell"];
            if (!cell) {
                cell = [[MasterCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"MasterCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.delegate = self;
            cell.model = self.masters[indexPath.row];
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
            UILabel *lbl1 = [cell.contentView viewWithTag:333];
            lbl1.text = NSLocalizedString(@"Нет доступных мастеров", @"");
            return cell;
        }
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section==0)
    {
        if (indexPath.row==0)
        {
            self.openFilter = !self.openFilter;
            if (self.openFilter)[self.searchBar resignFirstResponder];
            else [self.searchBar becomeFirstResponder];
                [self.tableView beginUpdates];
                if (self.openFilter==YES)[self.tableView insertRowsAtIndexPaths:[self getIndexes] withRowAnimation:UITableViewRowAnimationFade];
                else [self.tableView deleteRowsAtIndexPaths:[self getIndexes] withRowAnimation:UITableViewRowAnimationFade];
                [self.tableView endUpdates];
            self.filterCell.openFilter = self.openFilter;
        }
        else if (indexPath.row==1)
        {
            FilterSortingPicker *picker = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterSortingPicker"];
            picker.delegate = self;
            [self.navigationController pushViewController:picker animated:YES];
        }
        else if (indexPath.row==2)
        {
            CategoryPicker *picker = [self.storyboard instantiateViewControllerWithIdentifier:@"CategoryPicker"];
            picker.delegate = self;
            [self.navigationController pushViewController:picker animated:YES];
        }
        else if (indexPath.row==3)
        {
            FilterGenderPicker *picker = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterGenderPicker"];
            picker.delegate = self;
            [self.navigationController pushViewController:picker animated:YES];
        }
        else if (indexPath.row==4)
        {
            SelectLocationOnMap *picker =  [[SelectLocationOnMap alloc] init];
            picker.delegate = self;
            [self.navigationController pushViewController:picker animated:YES];
        }
    }
    else
    {
        if (self.masters.count>0)
        {
        }
    }
}

-(NSArray*)getIndexes
{
    NSArray *indexPaths = [[NSArray alloc] initWithObjects:
                                 [NSIndexPath indexPathForRow:1 inSection:0],
                                 [NSIndexPath indexPathForRow:2 inSection:0],
                                 [NSIndexPath indexPathForRow:3 inSection:0],
                                 [NSIndexPath indexPathForRow:4 inSection:0],
                                 [NSIndexPath indexPathForRow:5 inSection:0],
                                 [NSIndexPath indexPathForRow:6 inSection:0],
                                 [NSIndexPath indexPathForRow:7 inSection:0],
                                 [NSIndexPath indexPathForRow:8 inSection:0],
                                 nil];
    return indexPaths;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==0)
    {
        if (indexPath.row==8)return 162.0;
        else if (indexPath.row==0)
        {
            if (self.openFilter)return 44;
            else return self.filterCell.frame.size.height;
        }
        else return 44.0;
    }
    else
    {
        if (self.masters.count==0 || !self.masters)
        {
            NSInteger rh = (self.openFilter)?44*9+162:44;
            return (self.tableView.frame.size.height-rh-self.keyboardHeight-64>0)?self.tableView.frame.size.height-rh-self.keyboardHeight-64:0;
        }
        else return 230;
    }
}

-(void)keyboardOnScreen:(NSNotification *)notification
{
    NSDictionary *info  = notification.userInfo;
    NSValue      *value = info[UIKeyboardFrameEndUserInfoKey];
    
    CGRect rawFrame      = [value CGRectValue];
    CGRect keyboardFrame = [self.view convertRect:rawFrame fromView:nil];
    self.keyboardHeight = keyboardFrame.size.height;
    [self.tableView reloadData];
}

- (void)updateFilterData
{
    [self.tableView reloadData];
}

- (void)picker:(SelectLocationOnMap *)picker didChooseLocation:(NSDictionary *)placemark{
    [FilterManager saveCity:placemark];
    [self.tableView reloadData];
}

- (void)acceptFilter
{
    self.filterAccept = YES;
    if (self.openFilter)[self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self.filterCell rebuildBudges];
    
    [self sendSearchRequest];
}

- (void)resetFilter
{
     [self.filterCell rebuildBudges];
    [self sendSearchRequest];
}

- (void)sendSearchRequest
{
    self.masters = [[NSMutableArray alloc] init];
    [self.masters removeAllObjects];
    [[ApiManager new] search:[self generateParams] completition:^(id response, NSError *error) {
        for (NSDictionary *dict in response){
            MasterModel *master = [[MasterModel alloc] initWithDictionary:dict];
            [self.masters addObject:master];
        }
        [self.tableView reloadData];
    }];
}

- (NSDictionary*)generateParams{
    NSMutableDictionary *params= [NSMutableDictionary new];
    if ([FilterManager spec]!=nil)[params setObject:[FilterManager spec][@"id"] forKey:@"specialization"];
    if ([FilterManager gender]>0){
        NSString *gender = ([FilterManager gender]==1)?@"Муж":@"Жен";
        [params setObject:gender forKey:@"gender"];
    }
    [params setObject:[NSNumber numberWithBool:[FilterManager toHome]] forKey:@"visitathome"];
    [params setObject:[NSNumber numberWithBool:[FilterManager InMaster]] forKey:@"visit"];
    [params setObject:[NSNumber numberWithBool:[FilterManager withReviews]] forKey:@"reviewsonly"];
    
    [params setObject:@"0" forKey:@"minCost"];
    [params setObject:[FilterManager price] forKey:@"maxCost"];

    if ([FilterManager sortBy]>0){
        NSString *sortBy = ([FilterManager sortBy]==1)?@"rating":@"cost";
        [params setObject:sortBy forKey:@"orderBy"];
    }
    
    [params setObject:@"100" forKey:@"dist"];
    if ([FilterManager city][@"lat"]){
        [params setObject:[FilterManager city][@"lat"] forKey:@"lat"];
    }
    if ([FilterManager city][@"lon"]){
        [params setObject:[FilterManager city][@"lon"] forKey:@"lon"];
    }
    if (self.searchBar.text.length>0){
        [params setObject:self.searchBar.text forKey:@"request"];
    }
    return params;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self sendSearchRequest];
}

- (void)categoryPicker:(CategoryPicker *)cate didChooseCategory:(CategoryModel *)category{
    NSDictionary *catDict = @{@"id":category.id,@"name":category.name};
    [FilterManager saveSpec:catDict];
    [self updateFilterData];
    [cate.navigationController popToRootViewControllerAnimated:YES];
}

@end
