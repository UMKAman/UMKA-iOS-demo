//
//  AboutCellController.m
//  Umka
//
//  Created by Igor Zalisky on 12/21/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "AboutCellController.h"
#import "MasterModel.h"
#import "ReviewCell.h"
#import "RatingCell.h"
#import "ReviewModel.h"
#import "RatingModel.h"
#import "AboutCell.h"

@interface AboutCellController ()
@property (nonatomic, weak) IBOutlet UISegmentedControl *segmentControl;
@end

@implementation AboutCellController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *hv = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width-12, 44)];
    hv.backgroundColor = [UIColor whiteColor];
    self.segmentControl.frame = CGRectMake(([UIScreen mainScreen].bounds.size.width-12-240)/2, 14, 240, 30);
    [hv addSubview:self.segmentControl];
    [self changeTab:self.segmentControl];
    self.tableView.tableHeaderView = hv;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 140;
    
    NSLog(@"%@",NSStringFromCGRect(self.view.frame));
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)changeTab:(UISegmentedControl*)sender
{
    [self.tableView reloadData];
    [self performSelector:@selector(reloadDelegate) withObject:nil afterDelay:0.3];
}

#pragma mark - Table view data source


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.segmentControl.selectedSegmentIndex==1)return (self.master.ratingAndCouns.count>0)?self.master.ratingAndCouns.count:1;
    else return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.segmentControl.selectedSegmentIndex==1)
    {
        if (self.master.ratingAndCouns.count>0)
        {
            ReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ReviewCell"];
            if (!cell) {
                cell = [[ReviewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                         reuseIdentifier:@"ReviewCell"];
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            cell.model = self.master.reviews[indexPath.row];
            cell.delegate = self;
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
    else if (self.segmentControl.selectedSegmentIndex==0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"AboutTextCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"AboutTextCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UILabel *tv = [cell.contentView viewWithTag:67];
        tv.text = self.master.user.about;
        return cell;
    }
    else
    {
        RatingCell *cell = [tableView dequeueReusableCellWithIdentifier:@"RatingCell"];
        if (!cell) {
            cell = [[RatingCell alloc] initWithStyle:UITableViewCellStyleDefault
                                     reuseIdentifier:@"RatingCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        RatingModel *rating = [RatingModel new];
        rating.rating = self.master.averageRating.floatValue;
        rating.allReviews = self.master.voices.integerValue;
        cell.ratingModel = rating;
        cell.cellView.layer.shadowOpacity = 0.0;
        return cell;
    }
}


- (void)reloadDelegate
{
    [self.delegate reloadCell:self.tableView.contentSize.height+10];
}

@end
