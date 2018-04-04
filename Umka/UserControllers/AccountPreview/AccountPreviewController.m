//
//  AccountPreviewController.m
//  Umka
//
//  Created by Ігор on 26.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountPreviewController.h"
#import <CarbonKit/CarbonKit.h>
#import "Constants.h"
#import "AccountPreviewInfo.h"
#import "AccountPreviewPortfolio.h"
#import "AccountPreviewServices.h"
#import "AccountPreviewCategories.h"
#import <HCSStarRatingView/HCSStarRatingView.h>
#import "AccountPreviewSchedule.h"
#import "AccountPreviewReviews.h"

@interface AccountPreviewController ()<CarbonTabSwipeNavigationDelegate,UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    CarbonTabSwipeNavigation *carbonTabSwipeNavigation;
}
@property (nonatomic, weak) IBOutlet UIView *sliderView;
@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) IBOutlet UILabel *name;
@property (nonatomic, weak) IBOutlet UILabel *rating;
@property (nonatomic, weak) IBOutlet HCSStarRatingView *ratingView;
@end

@implementation AccountPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view layoutIfNeeded];
    self.title = NSLocalizedString(@"Профиль",@"");
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
    barButton.title = @"";
    self.navigationController.navigationBar.topItem.backBarButtonItem = barButton;
    [SVProgressHUD show];
    self.navigationItem.rightBarButtonItem = nil;
    self.navigationItem.leftBarButtonItem = nil;
    self.avatar.layer.cornerRadius = self.avatar.frame.size.height/2;
    self.ratingView.alpha = 0.0;
    if (self.master)[self loadMasterInfo];
    else [self updateUserInfo];
}

- (void)setupControls{
    carbonTabSwipeNavigation =
    [[CarbonTabSwipeNavigation alloc] initWithItems:@[NSLocalizedString(@"Инфо",@""),NSLocalizedString(@"Категории",@""),NSLocalizedString(@"Услуги",@""),NSLocalizedString(@"Портфолио",@""),NSLocalizedString(@"График",@""),NSLocalizedString(@"Отзывы",@""),NSLocalizedString(@"Рейтинг",@"")] delegate:self];
    [carbonTabSwipeNavigation insertIntoRootViewController:self andTargetView:self.sliderView];
    
    [carbonTabSwipeNavigation setNormalColor:[UIColor colorWithRed:54.0/255.0 green:64.0/255.0 blue:73.0/255.0 alpha:1.0] font:[UIFont fontWithName:@"HelveticaNeue" size:13*SCALE_COOF]];
    [carbonTabSwipeNavigation setSelectedColor:[UIColor colorWithRed:24.0/255.0 green:31.0/255.0 blue:57.0/255.0 alpha:1.0] font:[UIFont fontWithName:@"HelveticaNeue" size:13*SCALE_COOF]];
    
    [carbonTabSwipeNavigation setIndicatorColor:[UIColor colorWithRed:24.0/255.0 green:31.0/255.0 blue:57.0/255.0 alpha:1.0]];
    [carbonTabSwipeNavigation setIndicatorHeight:4.0];
    [carbonTabSwipeNavigation.toolbar setBackgroundColor:[UIColor whiteColor]];
    [carbonTabSwipeNavigation.toolbar setBarTintColor:[UIColor whiteColor]];
}

- (void)loadMasterInfo{
    [[ApiManager new] viewMasterProfile:self.master.id completition:^(id response, NSError *error) {
        self.master = [[MasterModel alloc] initWithDictionary:response];
        [self updateMasterInfo];
    }];
}

- (void)updateUserInfo{
    
    AccountPreviewInfo *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPreviewInfo"];
    vc.delegate = self;
    vc.user = self.user;
    [self.sliderView addSubview:vc.view];
    [SVProgressHUD dismiss];
    if (self.user){
        self.rating.alpha = 0.0;
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.user.pic]
                       placeholderImage:[UIImage imageNamed:@"ic_profile_no_avatar"]];
        self.name.text = self.user.name;
        self.ratingView.alpha = 0.0;
    }
}

- (void)updateMasterInfo{
    [self setupControls];
    [SVProgressHUD dismiss];
    if (self.master.user){
        self.ratingView.alpha = 1.0;
        self.rating.text = [NSString stringWithFormat:@"%@ %@",self.master.voices, [self reviewsWithCOunt:self.master.averageRating.integerValue]];
        [self.avatar sd_setImageWithURL:[NSURL URLWithString:self.master.user.pic]
                       placeholderImage:[UIImage imageNamed:@"ic_profile_no_avatar"]];
        self.name.text = self.master.user.name;
        self.ratingView.value = self.master.averageRating.floatValue;
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

- (UIViewController *)carbonTabSwipeNavigation:(CarbonTabSwipeNavigation *)carbonTabSwipeNavigation
                         viewControllerAtIndex:(NSUInteger)index {
    if (index==0){
        AccountPreviewInfo *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPreviewInfo"];
        vc.delegate = self;
        vc.master = self.master;
        return vc;
    }
    else if (index==1){
        AccountPreviewCategories *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPreviewCategories"];
        vc.delegate = self;
        vc.master = self.master;
        return vc;
    }
    else if (index==2){
        AccountPreviewServices *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPreviewServices"];
        vc.delegate = self;
        vc.master = self.master;
        return vc;
    }
    else if (index==3)
    {
        AccountPreviewPortfolio *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPreviewPortfolio"];
        vc.delegate = self;
        vc.master = self.master;
        return vc;
    }
    else if (index==4)
    {
        AccountPreviewSchedule *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPreviewSchedule"];
        vc.delegate = self;
        vc.master = self.master;
        return vc;
    }
    else if (index==5)
    {
        AccountPreviewReviews *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPreviewReviews"];
        vc.isRating = NO;
        vc.delegate = self;
        vc.master = self.master;
        return vc;
    }
    else
    {
        AccountPreviewReviews *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPreviewReviews"];
        vc.isRating = YES;
        vc.delegate = self;
        vc.master = self.master;
        return vc;
    }
    [self.view layoutIfNeeded];
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

@end
