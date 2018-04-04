//
//  PortfolioCell.m
//  Umka
//
//  Created by Igor Zalisky on 12/19/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "PortfolioCell.h"
#import "MasterModel.h"
#import "PortfolioItemCell.h"
#import "AddPortfolioItem.h"

@implementation PortfolioCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
    self.cellView.layer.masksToBounds = NO;
    self.cellView.layer.cornerRadius = 8;
    self.cellView.layer.shadowOffset = CGSizeMake(0, 0);
    self.cellView.layer.shadowRadius = 5;
    self.cellView.layer.shadowOpacity = 0.25;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMaster:(MasterModel *)master
{
    if (self.master!=master)
    {
        _master = master;
        self.title.text = [self getSpecializations:master.specializations];
        self.spec1.text = [self serviceName:NO index:0];
        self.spec2.text = [self serviceName:NO index:1];
        self.price1.text = [self serviceName:YES index:0];
        self.price2.text = [self serviceName:YES index:1];
        self.allPrices.hidden = self.master.services.count<=2;
        [self.portfolio reloadData];
    }
}

- (NSString*)getSpecializations:(NSArray*)services{
    NSMutableString *ms = [[NSMutableString alloc] initWithString:@""];
    for (CategoryModel *spec in services)
    {
        if (ms.length==0)[ms appendString:spec.name];
        else [ms appendFormat:@", %@",spec.name];
    }
    return [ms copy];
}

- (NSString *)serviceName:(BOOL)price index:(NSInteger)index
{
    NSString *rs = @"";
    if (self.master.services.count>index)
    {
        Service *service = self.master.services[index];
        rs = service.name;
        if (price) rs = [NSString stringWithFormat:@"%@ ₽ / %@ %@",service.cost,service.count,service.measure];
    }
    return rs;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.editMode) return self.master.portfolios.count+1;
    else return self.master.portfolios.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.editMode)
    {
        if (indexPath.row==0)
        {
            UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddNewPortfolioItem" forIndexPath:indexPath];
            return cell;
        }
        else 
        {
            PortfolioItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PortfolioItemCell" forIndexPath:indexPath];
            cell.item = self.master.portfolios[indexPath.row-1];
            return cell;
        }
    }
    else
    {
        PortfolioItemCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PortfolioItemCell" forIndexPath:indexPath];
        cell.item = self.master.portfolios[indexPath.row];
        return cell;
    }
}

#pragma mark <UICollectionViewDataSource>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.editMode==YES)
    {
        if (indexPath.row==0)
        {
            AddPortfolioItem *controller = [[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]] instantiateViewControllerWithIdentifier:@"AddPortfolioItem"];
            [[self.delegate navigationController] pushViewController:controller animated:YES];
        }
    }
    else
    {
        if (self.master.portfolios.count>0){
            
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(160, 113);
}



@end
