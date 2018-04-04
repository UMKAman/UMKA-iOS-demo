//
//  AdWithMeTopTableViewController.m
//  AdWithMe
//
//  Created by Igor Zaliskyj on 4/2/16.
//  Copyright © 2016 AdWithMe. All rights reserved.
//

#import "UmkaTopTableViewController.h"
#import "LeftMenuController.h"
#import "AppDelegate.h"
#import "SearchFilterController.h"

@interface UmkaTopTableViewController ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL interactiveGestureEnabled;
@end

@implementation UmkaTopTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBarHidden = NO;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu) name:kLGSideMenuControllerWillDismissLeftViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu) name:kLGSideMenuControllerWillShowLeftViewNotification object:nil];
    self.menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 44, 44)];
    [self.menuBtn setImage:[UIImage imageNamed:@"ic_navbar_side_menu"] forState:UIControlStateNormal];
    [self.menuBtn addTarget:self action:@selector(menuButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuBtn];
    self.navigationItem.leftBarButtonItem = barItem;
    
    NSString *appMode = [UmkaUser appMode];
    if (![appMode isEqualToString:@"master"])
    {
    self.searchBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 44, 44)];
    [self.searchBtn setImage:[UIImage imageNamed:@"ic_navbar_search"] forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:self.searchBtn];
    self.navigationItem.rightBarButtonItem = searchItem;
    }
}

- (void)searchAction
{
    SearchFilterController *sfc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchFilterController"];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:sfc];
    nc.navigationBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController.interactivePopGestureRecognizer setDelegate:self];
    if (self.navigationController.viewControllers.count>1)
    {
        self.interactiveGestureEnabled = YES;
        LeftMenuController * menuVC = kMainViewController;
        menuVC.leftViewSwipeGestureEnabled = NO;
        menuVC.rightViewSwipeGestureEnabled = NO;
        [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
    }
    else
    {
        self.interactiveGestureEnabled = NO;
        LeftMenuController * menuVC = kMainViewController;
        menuVC.leftViewSwipeGestureEnabled = YES;
        menuVC.rightViewSwipeGestureEnabled = YES;
        [self.navigationController.interactivePopGestureRecognizer setEnabled:NO];
    }
}

-(void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    self.interactiveGestureEnabled = YES;
    LeftMenuController * menuVC = kMainViewController;
    menuVC.leftViewSwipeGestureEnabled = NO;
    menuVC.rightViewSwipeGestureEnabled = NO;
     [self.navigationController.interactivePopGestureRecognizer setEnabled:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return self.interactiveGestureEnabled;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRequireFailureOfGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (IBAction)menuButton:(UIButton *)sender {
    [self.menuBtn setImage:[UIImage imageNamed:@"ic_navbar_side_menu"] forState:UIControlStateNormal];
    [kMainViewController showLeftViewAnimated:YES completionHandler:nil];
}

- (void)hideMenu
{
    [self.menuBtn setImage:[UIImage imageNamed:@"ic_navbar_side_menu"] forState:UIControlStateNormal];
}

- (void)showMenu
{
    [self.menuBtn setImage:[UIImage imageNamed:@"ic_navbar_side_menu"] forState:UIControlStateNormal];
}




@end
