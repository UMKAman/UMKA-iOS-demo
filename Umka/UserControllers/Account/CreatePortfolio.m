//
//  CreatePortfolio.m
//  Umka
//
//  Created by Ігор on 24.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "CreatePortfolio.h"
#import "PortfolioImage.h"

@interface CreatePortfolio ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, assign) BOOL _edit;
@property (nonatomic, strong) NSMutableArray *images;
@end

@implementation CreatePortfolio

- (void)viewDidLoad {
    [super viewDidLoad];
    self.name.placeholder = NSLocalizedString(@"Название работы", @"");
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 30, 44)];
    [editBtn setImage:[UIImage imageNamed:@"navbar_save"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(createPortfolio) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    self.images = [NSMutableArray new];
    if (!self.portfolio)self.portfolio = [Portfolio new];
    else {
        self.name.text = self.portfolio.descr;
        self._edit = YES;
        [[ApiManager new] getImagesForPortfolio:self.portfolio.id completition:^(id response, NSError *error) {
            for (NSDictionary *dict in response){
                PortfolioImage *image = [[PortfolioImage alloc] initWithDict:dict];
                [self.images addObject:image];
            }
            [self.collection reloadData];
        }];
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
    return self.images.count+1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row==self.images.count){
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"AddCell" forIndexPath:indexPath];
        return cell;
    }
    else{
        PortfolioImage *pi = self.images[indexPath.row];
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PortfolioCell" forIndexPath:indexPath];
        UIImageView *iv = [cell.contentView viewWithTag:100];
        [iv sd_setImageWithURL:[NSURL URLWithString:pi.pic] placeholderImage:[UIImage imageNamed:@"photo_delete"]];
        UIImageView *iv1 = [cell.contentView viewWithTag:200];
        iv1.image = [UIImage imageNamed:@"photo_delete"];
        iv1.alpha = [self editingMode]==YES;
        return cell;
    }
}

#pragma mark <UICollectionViewDataSource>


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (self.images.count==indexPath.row)[self chooseImage];
    else if (self.editingMode){
        PortfolioImage *image = self.images[indexPath.row];
        [self removeImage:image.id];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(([UIScreen mainScreen].bounds.size.width - 40)/3, ([UIScreen mainScreen].bounds.size.width - 40)/3);
}

- (void)createPortfolio{
    if (self.name.text.length>0 && self.images.count>0){
    if (self._edit){
        [[ApiManager new] updatePortfolio:@{@"description":self.name.text} item:self.portfolio.id completition:^(id response, NSError *error) {
            if (response && !error){
                self.portfolio.descr = response[@"description"];
                self.portfolio.id = response[@"id"];
            }
            [self.delegate portfolioDidChanged:self.portfolio];
             [self.navigationController popViewControllerAnimated:YES];
        }];
    }
    else {
    [[ApiManager new] addPortfolio:@{@"description":self.name.text} completition:^(id response, NSError *error) {
        if (response && !error){
        self.portfolio.descr = response[@"description"];
        self.portfolio.id = response[@"id"];
        [self.delegate portfolioDidCreated:self.portfolio];
        }
         [self.navigationController popViewControllerAnimated:YES];
    }];
    }
    }
    else {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Умка",@"")
                                                                        message:NSLocalizedString(@"Сначала введите название и добавьте фотографии",@"")
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {[alert dismissViewControllerAnimated:YES completion:nil];}];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
    }
}



- (void)chooseImage{
    [self.view endEditing:YES];
    if (self.portfolio.id.integerValue==0 && self.name.text.length==0)
    {
        UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Умка",@"")
                                                                        message:NSLocalizedString(@"Сначала введите название",@"")
                                                                 preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"")
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction * action)
                             {[alert dismissViewControllerAnimated:YES completion:nil];}];
        [alert addAction:ok];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:NSLocalizedString(@"Выбрать аватар",@"")
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    view.popoverPresentationController.sourceView = self.view;
    view.popoverPresentationController.sourceRect = self.view.bounds;
    
    UIAlertAction* gallery = [UIAlertAction
                              actionWithTitle:NSLocalizedString(@"Фотогалерея",@"")
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [self selectFile:NO];
                                  [view dismissViewControllerAnimated:YES completion:nil];
                                  
                              }];
    [view addAction:gallery];
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIAlertAction* camera = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"Камера",@"")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [self selectFile:YES];
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                 }];
        [view addAction:camera];
    }
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Отмена",@"")
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    
    [view addAction:cancel];
    [self presentViewController:view animated:YES completion:nil];
}

- (void)selectFile:(BOOL)camera
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = (camera)?UIImagePickerControllerSourceTypeCamera:UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    if (self.portfolio.id.integerValue>0)[self uploadImage:image];
    else [self addPortfolio:image];
}

- (void)uploadImage:(UIImage*)image{
    [SVProgressHUD show];
    [[ApiManager new] uploadImage:image forPortfolio:self.portfolio.id completition:^(id response, NSError *error) {
        [self loadImages];
    }];
}

- (void)loadImages{
    [[ApiManager new] getImagesForPortfolio:self.portfolio.id completition:^(id response, NSError *error) {
        [self.images removeAllObjects];
        for (NSDictionary *dict in response){
            PortfolioImage *image = [[PortfolioImage alloc] initWithDict:dict];
            [self.images addObject:image];
            [SVProgressHUD dismiss];
        }
        [self.collection reloadData];
    }];
}

- (void)addPortfolio:(UIImage*)image{
    self._edit = YES;
    [[ApiManager new] addPortfolio:@{@"description":self.name.text} completition:^(id response, NSError *error) {
        if (response && !error){
            self.portfolio.descr = response[@"description"];
            self.portfolio.id = response[@"id"];
            [self uploadImage:image];
        }
    }];
}

- (void)removeImage:(NSNumber*)imageID{
    [[ApiManager new] delImage:imageID completition:^(id response, NSError *error) {
        [self loadImages];
    }];
}

@end
