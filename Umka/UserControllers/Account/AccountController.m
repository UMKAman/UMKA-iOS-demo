//
//  UserProfileController.m
//  7Cases
//
//  Created by Igor Zalisky on 2/5/17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountController.h"
#import <CarbonKit/CarbonKit.h>
#import "Constants.h"
#import "AccountInfo.h"
#import "AccountPortfolio.h"
#import "AccountServices.h"
#import "AccountCategories.h"
#import <HCSStarRatingView/HCSStarRatingView.h>

@interface AccountController ()<CarbonTabSwipeNavigationDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
}
@property (nonatomic, weak) IBOutlet UIView *sliderView;
@property (nonatomic, strong) AccountInfo *accountInfo;
@property (nonatomic, strong) UIButton *editBtn;
@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *rating;
@property (nonatomic, weak) IBOutlet UITextField *userName;
@property (nonatomic, weak) IBOutlet HCSStarRatingView *ratingView;
@end

@implementation AccountController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    self.title = NSLocalizedString(@"Профиль", @"");
    self.userName.placeholder = NSLocalizedString(@"Имя пользователя", @"");
    [SVProgressHUD show];
    self.navigationItem.rightBarButtonItem = nil;
    self.ratingView.alpha = 0.0;
    self.userName.alpha = 0.0;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height/2;
    if ([UmkaUser isUser])[self updateUserInfo];
    else {
    if ([UmkaUser masterID]==0)[self findOrCreateMaster];
    else [self loadMasterInfo];
    }
}

- (void)updateUserInfo{
    
    self.accountInfo = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountInfo"];
    self.accountInfo.delegate = self;
    self.accountInfo.user = self.user;
    [self.sliderView addSubview:self.accountInfo.view];
    [SVProgressHUD dismiss];
    if (self.user){
        self.userName.alpha = 1.0;
        self.rating.alpha = 0.0;
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.user.pic]
                       placeholderImage:[UIImage imageNamed:@"ic_profile_no_avatar"]];
        self.name.text = self.user.name;
        self.ratingView.alpha = 0.0;
        self.userName.text = self.user.name;
    }
}

- (void)setupControls{
    carbonTabSwipeNavigation =
    [[CarbonTabSwipeNavigation alloc] initWithItems:@[NSLocalizedString(@"Инфо",@""),NSLocalizedString(@"Категории",@""),NSLocalizedString(@"Услуги",@""),NSLocalizedString(@"Портфолио",@"")] delegate:self];
    [carbonTabSwipeNavigation insertIntoRootViewController:self andTargetView:self.sliderView];
    
    [carbonTabSwipeNavigation setNormalColor:[UIColor colorWithRed:54.0/255.0 green:64.0/255.0 blue:73.0/255.0 alpha:1.0] font:[UIFont fontWithName:@"HelveticaNeue" size:13*SCALE_COOF]];
    [carbonTabSwipeNavigation setSelectedColor:[UIColor colorWithRed:24.0/255.0 green:31.0/255.0 blue:57.0/255.0 alpha:1.0] font:[UIFont fontWithName:@"HelveticaNeue" size:13*SCALE_COOF]];
    
    [carbonTabSwipeNavigation setIndicatorColor:[UIColor colorWithRed:24.0/255.0 green:31.0/255.0 blue:57.0/255.0 alpha:1.0]];
    [carbonTabSwipeNavigation setIndicatorHeight:4.0];
    CGFloat tabWidth = [UIScreen mainScreen].bounds.size.width/4;
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:tabWidth forSegmentAtIndex:0];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:tabWidth forSegmentAtIndex:1];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:tabWidth forSegmentAtIndex:2];
    [carbonTabSwipeNavigation.carbonSegmentedControl setWidth:tabWidth forSegmentAtIndex:3];
    
    [carbonTabSwipeNavigation.toolbar setBackgroundColor:[UIColor whiteColor]];
    [carbonTabSwipeNavigation.toolbar setBarTintColor:[UIColor whiteColor]];
}

- (void)findOrCreateMaster{
    [[ApiManager new] getAllMastersCompletition:^(id response, NSError *error) {
        for (NSDictionary *dict in response){
            MasterModel *model = [[MasterModel alloc] initWithDictionary:dict];
            if (model.user.id.integerValue==[UmkaUser userID]){
                [UmkaUser saveMasterID:model.id.integerValue];
                 self.master = model;
                [self updateMasterInfo];
                break;
            }
        }
        if (!self.master){
            [[ApiManager new] createMasterCompletition:^(id response, NSError *error) {
                if (![response[@"name"] isEqualToString:@"Error"]){
                [UmkaUser saveMasterID:[response[@"id"] integerValue]];
                [self loadMasterInfo];
                }
            }];
        }
    }];
}

- (void)loadMasterInfo{
    [[ApiManager new] viewMasterProfile:[NSString stringWithFormat:@"%ld",[UmkaUser masterID]] completition:^(id response, NSError *error) {
        self.master = [[MasterModel alloc] initWithDictionary:response];
        [self updateMasterInfo];
    }];
}

- (void)updateMasterInfo{
    [self setupControls];
    [SVProgressHUD dismiss];
    if (self.master.user){
        self.ratingView.alpha = 1.0;
        self.userName.alpha = 1.0;
    self.rating.text = [NSString stringWithFormat:@"%@ %@",self.master.voices, [self reviewsWithCOunt:self.master.averageRating.integerValue]];
    [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.master.user.pic]
                   placeholderImage:[UIImage imageNamed:@"ic_profile_no_avatar"]];
    self.name.text = self.master.user.name;
    self.ratingView.value = self.master.averageRating.floatValue;
    self.userName.text = self.master.user.name;
    }
}

- (NSString*)reviewsWithCOunt:(NSInteger)count{
    if (count%10==1 && count!=11) return NSLocalizedString(@"отзыв",@"");
    else if (count%10>1 &&count%10<5 && count!=12&& count!=13&& count!=14)return NSLocalizedString(@"отзыва",@"");
    else return NSLocalizedString(@"отзывов",@"");
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)editAction
{
    if (!self.editingMode)
    {
        [self.editBtn setImage:[UIImage imageNamed:@"navbar_save"] forState:UIControlStateNormal];
        [self.editBtn setImage:[UIImage imageNamed:@"navbar_save_a"] forState:UIControlStateSelected];
    }
    else
    {
        [self.editBtn setImage:[UIImage imageNamed:@"navbar_edit"] forState:UIControlStateNormal];
        [self.editBtn setImage:[UIImage imageNamed:@"navbar_edit_a"] forState:UIControlStateSelected];
    }
    self.editingMode = !self.editingMode;
    
    id controllers = carbonTabSwipeNavigation.viewControllers;
    if ([controllers isKindOfClass:[NSDictionary class]])
    {
        NSDictionary *dict = (NSDictionary*)controllers;
        for (id vc in dict.allValues)
        {
            if ([vc isKindOfClass:[AccountInfo class]])
                [(AccountInfo*)vc setEditingMode:self.editingMode];
            if ([vc isKindOfClass:[AccountPortfolio class]])
                [(AccountPortfolio*)vc setEditingMode:self.editingMode];
            if ([vc isKindOfClass:[AccountCategories class]])
                [(AccountCategories*)vc setEditingMode:self.editingMode];
            if ([vc isKindOfClass:[AccountServices class]])
                [(AccountServices*)vc setEditingMode:self.editingMode];
        }
    }
    else
    {
        id vc = controllers;
        if ([vc isKindOfClass:[AccountInfo class]])
            [(AccountInfo*)vc setEditingMode:self.editingMode];
        if ([vc isKindOfClass:[AccountPortfolio class]])
            [(AccountPortfolio*)vc setEditingMode:self.editingMode];
        if ([vc isKindOfClass:[AccountCategories class]])
            [(AccountCategories*)vc setEditingMode:self.editingMode];
        if ([vc isKindOfClass:[AccountServices class]])
            [(AccountServices*)vc setEditingMode:self.editingMode];
    }
}

- (UIViewController *)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                         viewControllerAtIndex:(NSUInteger)index {
    if (index==0){
        AccountInfo *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountInfo"];
        vc.delegate = self;
        vc.master = self.master;
        return vc;
    }
    else if (index==1){
        AccountCategories *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountCategories"];
        vc.delegate = self;
        vc.master = self.master;
        return vc;
    }
    else if (index==2){
        AccountServices *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountServices"];
        vc.delegate = self;
        vc.master = self.master;
        return vc;
    }
    else
    {
        AccountPortfolio *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPortfolio"];
        vc.delegate = self;
        vc.master = self.master;
        return vc;
    }
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                  didMoveAtIndex:(NSUInteger)index {
    
    NSLog(@"Did move at index: %ld", (unsigned long)index);
}

- (void)carbonTabSwipeNavigation:(nonnull CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                 willMoveAtIndex:(NSUInteger)index {
    //self.title = self.categories[index];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    if (textField.text.length>0){
        [[ApiManager new] updateUser:self.master.user.id params:@{@"name":textField.text} completition:^(id response, NSError *error) {
            NSLog(@"%@",response);
        }];
    }
    return YES;
}


- (IBAction)chooseImage{
    [self.view endEditing:YES];
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
    [self uploadImage:image];
}

- (void)uploadImage:(UIImage*)image{
    self.avatar.image = image;
    [SVProgressHUD show];
    [[ApiManager new] uploadImage:image userID:self.user.id completition:^(id response, NSError *error) {
        [SVProgressHUD dismiss];
    }];
}


@end
