//
//  AccountPreviewReviews.m
//  Umka
//
//  Created by Ігор on 27.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountPreviewReviews.h"
#import "ReviewModel.h"
#import "ReviewCell.h"
#import "RatingCell.h"
#import "RatingModel.h"

@interface AccountPreviewReviews ()
@property (nonatomic, strong) NSMutableArray *reviews;
@property (nonatomic, strong) RatingModel *rating;
@end

@implementation AccountPreviewReviews

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor clearColor];
    self.refreshControl.tintColor = [UIColor lightGrayColor];
    [self.refreshControl addTarget:self
                            action:@selector(getLatestLoans)
                  forControlEvents:UIControlEventValueChanged];
    
    self.reviews = [[NSMutableArray alloc] init];
    [self.reviews removeAllObjects];
    
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    [self loadMasterInfo];
}

- (void)loadMasterInfo{
    [[ApiManager new] getReviews:self.master.id completition:^(id response, NSError *error) {
        NSMutableDictionary *rac = [NSMutableDictionary new];
        for (NSDictionary *dict in response){
            ReviewModel *model = [[ReviewModel alloc] initWithDictionary:dict];
            [self.reviews addObject:model];
            NSInteger count =  [rac[model.review_rating] integerValue];
            [rac setObject:[NSNumber numberWithInteger:count+1] forKey:model.review_rating];
        }
        
        self.rating = [[RatingModel alloc] initWithDictionary:rac];
        [self.tableView reloadData];
    }];
}


- (void)getLatestLoans
{
    [self performSelector:@selector(refreshInfo) withObject:nil afterDelay:2.0];
}

- (void)refreshInfo
{
    [self.refreshControl endRefreshing];
    self.reviews = [[NSMutableArray alloc] init];
    [self.reviews removeAllObjects];
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
    if (!self.isRating)return (self.reviews.count>0)?self.reviews.count:1;
    else return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (!self.isRating)
    {
        if (self.reviews==nil)
        {
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LoadingCell"];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                              reuseIdentifier:@"LoadingCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.textLabel.text = NSLocalizedString(@"Загрузка...",@"");
            cell.textLabel.textAlignment = NSTextAlignmentCenter;
            cell.textLabel.textColor = [UIColor lightGrayColor];
            return cell;
        }
        else if (self.reviews.count>0)
        {
            ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
            if (!cell) {
                cell = [[ReviewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"ReviewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            ReviewModel *model = self.reviews[indexPath.row];
            cell.delegate = self;
            cell.model = model;
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
            return cell;
        }
    }
    else
    {
        RatingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RatingCell"];
        if (!cell) {
            cell = [[RatingCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"RatingCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.ratingModel = self.rating;
        return cell;
    }
}

@end
