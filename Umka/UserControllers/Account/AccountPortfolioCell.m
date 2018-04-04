//
//  AccountPortfolioCell.m
//  Umka
//
//  Created by Ігор on 24.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountPortfolioCell.h"
#import "AccountPortfolio.h"
#import "PortfolioImage.h"
#import <MWPhotoBrowser/MWPhotoBrowser.h>

@interface AccountPortfolioCell()<MWPhotoBrowserDelegate>{
    NSMutableArray *photos;
}
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation AccountPortfolioCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.images = [NSMutableArray new];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPortfolio:(Portfolio *)portfolio{
    if (self.portfolio!=portfolio){
        _portfolio = portfolio;
        self.name.text = portfolio.descr;
        self.images = [NSMutableArray new];
        [[ApiManager new] getImagesForPortfolio:self.portfolio.id completition:^(id response, NSError *error) {
            [self.images removeAllObjects];
            for (NSDictionary *dict in response){
                PortfolioImage *image = [[PortfolioImage alloc] initWithDict:dict];
                [self.images addObject:image];
            }
            [self.collection reloadData];
        }];
    }
}

- (void)reloadImages{
    [[ApiManager new] getImagesForPortfolio:self.portfolio.id completition:^(id response, NSError *error) {
        if ([(NSArray*)response count]!=self.images.count)
        {
        [self.images removeAllObjects];
        for (NSDictionary *dict in response){
            PortfolioImage *image = [[PortfolioImage alloc] initWithDict:dict];
            if (![self.images containsObject:image])[self.images addObject:image];
        }
        [self.collection reloadData];
        }
    }];
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    {
        PortfolioImage *pi = self.images[indexPath.row];
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PortfolioCell" forIndexPath:indexPath];
        UIImageView *iv = [cell.contentView viewWithTag:100];
        [iv sd_setImageWithURL:[NSURL URLWithString:pi.pic] placeholderImage:[UIImage imageNamed:@"photo_delete"]];
        return cell;
    }
}

#pragma mark <UICollectionViewDataSource>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self setupPhotoBrouser:indexPath.row];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(100,100);
}

- (IBAction)editAction:(id)sender{
    [[self delegate] editPortfolio:self.indexPath];
}

- (IBAction)deleteAction:(id)sender{
    [[self delegate] removePortfolio:self.indexPath];
}

- (void)setupPhotoBrouser:(NSInteger)index{
    photos = [NSMutableArray array];
    
    for (PortfolioImage *image in self.images){
    [photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:image.pic]]];
    }
    
    // Create browser (must be done each time photo browser is
    // displayed. Photo browser objects cannot be re-used)
    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    
    // Set options
    browser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    browser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    browser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    browser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    browser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    browser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    browser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    browser.autoPlayOnAppear = NO; // Auto-play first video
    
    // Customise selection images to change colours if required
    browser.customImageSelectedIconName = @"ImageSelected.png";
    browser.customImageSelectedSmallIconName = @"ImageSelectedSmall.png";
    
    // Optionally set the current visible photo before displaying
    [browser setCurrentPhotoIndex:index];
    
    // Present
    [[self.delegate navigationController] pushViewController:browser animated:YES];
    
    // Manipulate
    [browser showNextPhotoAnimated:YES];
    [browser showPreviousPhotoAnimated:YES];
    [browser setCurrentPhotoIndex:index];
}

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < photos.count) {
        return [photos objectAtIndex:index];
    }
    return nil;
}

@end
