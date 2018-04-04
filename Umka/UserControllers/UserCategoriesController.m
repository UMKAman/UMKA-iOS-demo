//
//  UserCategoriesController.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserCategoriesController.h"
#import "UserCategoryCell.h"
#import "CategoryModel.h"
#import "ApiManager.h"
#import "UserServicesController.h"
#import "UserMastersList.h"
#import "FilterManager.h"

@interface UserCategoriesController ()
@property (nonatomic, strong) NSMutableArray *categoriesArray;
@property (nonatomic, strong) NSArray *allCategories;
@end

@implementation UserCategoriesController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"Категории",@"");
    [self loadOffline];
    [self loadCategories];
    [self.navigationItem.backBarButtonItem setTitle:@" "];
}

- (void)loadCategories
{
    [[ApiManager new] getCategoriesCompletition:^(NSArray *jsonObject, NSError *error) {
        [self.categoriesArray removeAllObjects];
        self.categoriesArray = [[NSMutableArray alloc] init];
        self.allCategories = jsonObject;
        //if ([jsonObject isKindOfClass:[NSArray class]] && jsonObject.count>0)[FilterManager saveCategories:jsonObject];
        //else jsonObject = [FilterManager allCategories];
        for (NSDictionary *dict in jsonObject)
        {
            CategoryModel *model = [[CategoryModel alloc] initWithDictionary:dict];
            if (!model.parent)[self.categoriesArray addObject:model];
        }
        [self.collectionView reloadData];
    }];
}

- (void)loadOffline
{
    self.categoriesArray = [[NSMutableArray alloc] init];
    NSArray *jsonObject = [FilterManager allCategories];
    for (NSDictionary *dict in jsonObject)
    {
        CategoryModel *model = [[CategoryModel alloc] initWithDictionary:dict];
        [self.categoriesArray addObject:model];
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return (self.categoriesArray)?self.categoriesArray.count:1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.categoriesArray && self.categoriesArray.count>0)
    {
    UserCategoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"UserCategoryCell" forIndexPath:indexPath];
    CategoryModel* model = [self.categoriesArray objectAtIndex:indexPath.row];
    cell.model = model;
    return cell;
    }
    else
    {
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"LoadingCell" forIndexPath:indexPath];
        return cell;
    }
}

#pragma mark <UICollectionViewDataSource>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.categoriesArray.count>0)
    {
        CategoryModel* model = [self.categoriesArray objectAtIndex:indexPath.row];
        NSMutableArray *servicesArray = [self getServicesForSection:model];
        if (servicesArray.count>0){
        UserServicesController *tvc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserServicesController"];
        tvc.services = servicesArray;
            tvc.allCategories = self.allCategories;
        tvc.sectionTitle = model.name;
        [self.navigationController pushViewController:tvc animated:YES];
        }
        else{
            UserMastersList *uml = [self.storyboard instantiateViewControllerWithIdentifier:@"UserMastersList"];
            uml.model = model;
            [self.navigationController pushViewController:uml animated:YES];
        }
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = ([UIScreen mainScreen].bounds.size.width - 42)/2;
    if (self.categoriesArray && self.categoriesArray.count>0)
        return CGSizeMake(width, width*0.65);
    else return CGSizeMake([UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height-113);
}

- (NSMutableArray*)getServicesForSection:(CategoryModel*)section
{
    NSMutableArray *ta = [[NSMutableArray alloc] init];
    for (NSDictionary *dict in self.allCategories){
        CategoryModel *model = [[CategoryModel alloc] initWithDictionary:dict];
        if (model.parent.id.integerValue==section.id.integerValue)[ta addObject:model];
    }
    return ta;
}


@end
