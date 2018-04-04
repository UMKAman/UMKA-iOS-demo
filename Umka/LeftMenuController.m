//
//  ViewController.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "LeftMenuController.h"
#import "LeftMenuTable.h"
#import "Constants.h"
#import "UmkaUser.h"

@interface LeftMenuController ()

@end

@implementation LeftMenuController

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.leftViewStatusBarStyle = UIStatusBarStyleLightContent;
    //self.rootViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"NavigationController"];
    UIColor *color = [UIColor colorWithRed:24.0/255.0 green:31.0/255.0 blue:57.0/255.0 alpha:1.0];
    NSString *appMode = [UmkaUser appMode];
    if ([appMode isEqualToString:@"user"])
    {
        id controller = [self.storyboard instantiateViewControllerWithIdentifier:@"UmkaTabbarController"];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
        nc.navigationBar.barTintColor = color;
        nc.navigationBar.tintColor = [UIColor whiteColor];
        self.rootViewController = nc;
    }
    else
    {
        id controller = [self.storyboard instantiateViewControllerWithIdentifier:@"UmkaMasterTabbarController"];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
        nc.navigationBar.barTintColor = color;
        nc.navigationBar.tintColor = [UIColor whiteColor];
        self.rootViewController = nc;
    }
    _leftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"LeftMenuTable"];
    
   /* if ([[AMPreference userMode] isEqualToString:kUserAdvertizerMode])
    {
        self.rootViewController = [ [UIStoryboard storyboardWithName:@"MainAdv" bundle:nil] instantiateViewControllerWithIdentifier:@"NavigationController"];
        _leftViewController = [ [UIStoryboard storyboardWithName:@"MainAdv" bundle:nil] instantiateViewControllerWithIdentifier:@"MenuViewController"];
    }*/
    
    [self setLeftViewEnabledWithWidth:[UIScreen mainScreen].bounds.size.width*0.74
                    presentationStyle:LGSideMenuPresentationStyleSlideBelow
                 alwaysVisibleOptions:0];
    
    self.leftViewBackgroundImage = [UIImage imageNamed:@"side_nav_bg"];
    
    // -----
    
    _leftViewController.tableView.backgroundColor = [UIColor clearColor];
    _leftViewController.tintColor = [UIColor whiteColor];
    [_leftViewController.tableView reloadData];
    [self.leftView addSubview:_leftViewController.tableView];
}

- (void)showLeftViewAnimated:(BOOL)animated completionHandler:(void (^)())completionHandler
{
    [super showLeftViewAnimated:animated completionHandler:completionHandler];
    [_leftViewController viewProfile];
}

@end
