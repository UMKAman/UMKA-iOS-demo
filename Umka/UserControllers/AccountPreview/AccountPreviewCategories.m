//
//  AccountPreviewCategories.m
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountPreviewCategories.h"
#import "UserProfileCell.h"
#import "AccountCategoryCell.h"

@interface AccountPreviewCategories ()
@property (nonatomic, strong) NSMutableArray *allCategories;
@end

@implementation AccountPreviewCategories

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self loadAllCategories];
}

-(void)loadAllCategories{
    [[ApiManager new] getCategoriesCompletition:^(NSArray *jsonObject, NSError *error) {
        self.allCategories = [NSMutableArray new];
        for (NSDictionary *dict in jsonObject){
            CategoryModel *model = [[CategoryModel alloc] initWithDictionary:dict];
            [self.allCategories addObject:model];
        }
        [self.tableView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return (self.allCategories.count>0)?1:0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.master.specializations.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.master.specializations.count>0)
    {
        AccountCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:@"category"];
        if (!cell) {
            cell = [[AccountCategoryCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"category"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.categories = self.allCategories;
        cell.category = self.master.specializations[indexPath.row];
        cell.delegate = self;
        return cell;
    }
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

@end
