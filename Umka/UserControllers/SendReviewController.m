//
//  SendReviewController.m
//  Umka
//
//  Created by Igor Zalisky on 12/7/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "SendReviewController.h"
#import "ReviewCell.h"
#import "ReviewModel.h"
#import "SerdReviewCell.h"

@interface SendReviewController ()
@property (nonatomic,strong) NSMutableArray *reviews;
@end

@implementation SendReviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    self.title = NSLocalizedString(@"Оставить отзыв",@"");
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    [self loadReviews];
}

- (void)loadReviews{
    self.reviews = [NSMutableArray new];
    [self.reviews removeAllObjects];
    [[ApiManager new] getReviews:self.order.master.id completition:^(id response, NSError *error) {
        for (NSDictionary *dict in response){
            ReviewModel *model = [[ReviewModel alloc] initWithDictionary:dict];
            [self.reviews addObject:model];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.reviews.count+1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.row==0)
    {
        SerdReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SerdReviewCell"];
        if (!cell) {
            cell = [[SerdReviewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"SerdReviewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.delegate = self;
        cell.order = self.order;
        cell.review = [self reviewWasSend];
        return cell;
    }
    else
    {
        ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
        if (!cell) {
            cell = [[ReviewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"ReviewCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.model = self.reviews[indexPath.row-1];
        cell.delegate = self;
        return cell;
    }
}


- (ReviewModel*)reviewWasSend{
    ReviewModel *review = nil;
    for (ReviewModel *rm in self.reviews){
        if (rm.user.id.integerValue==[UmkaUser userID]){
            review = rm;
            break;
        }
    }
    return review;
}

@end
