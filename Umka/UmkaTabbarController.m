//
//  UmkaTabbarController.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UmkaTabbarController.h"
#import "LeftMenuController.h"
#import "AppDelegate.h"

@interface UmkaTabbarController ()<UIGestureRecognizerDelegate>
@property (nonatomic, assign) BOOL interactiveGestureEnabled;
@end

@implementation UmkaTabbarController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(hideMenu) name:kLGSideMenuControllerWillDismissLeftViewNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showMenu) name:kLGSideMenuControllerWillShowLeftViewNotification object:nil];
    self.menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 44, 44)];
    [self.menuBtn setImage:[UIImage imageNamed:@"ic_navbar_side_menu"] forState:UIControlStateNormal];
    [self.menuBtn addTarget:self action:@selector(menuButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:self.menuBtn];
    self.navigationItem.leftBarButtonItem = barItem;
    self.tabBar.tintColor = [UIColor whiteColor];
    self.title = NSLocalizedString(@"Умка", @"");
    self.navigationController.navigationBarHidden = YES;
    
    if ([UmkaUser isUser]){
    [[self.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"Категории", @"")];
    [[self.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"Сообщения", @"")];
    [[self.tabBar.items objectAtIndex:2] setTitle:NSLocalizedString(@"Карта", @"")];
    }
    else {
        [[self.tabBar.items objectAtIndex:0] setTitle:NSLocalizedString(@"График", @"")];
        [[self.tabBar.items objectAtIndex:1] setTitle:NSLocalizedString(@"Сообщения", @"")];
        [[self.tabBar.items objectAtIndex:2] setTitle:NSLocalizedString(@"Заказы", @"")];
    }
}

- (void)changeToBack
{
    self.menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 44, 44)];
    [self.menuBtn setImage:[UIImage imageNamed:@"ic_navbar_side_menu"] forState:UIControlStateNormal];
    [self.menuBtn addTarget:self action:@selector(backAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)changeToMenu
{
    self.menuBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 44, 44)];
    [self.menuBtn setImage:[UIImage imageNamed:@"ic_navbar_side_menu"] forState:UIControlStateNormal];
    [self.menuBtn addTarget:self action:@selector(menuButton:) forControlEvents:UIControlEventTouchUpInside];
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

- (IBAction)backAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
