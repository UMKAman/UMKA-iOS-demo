//
//  EditAboutTextController.m
//  Umka
//
//  Created by Igor Zalisky on 12/23/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "EditAboutTextController.h"
#import "UmkaUser.h"
#import "ApiManager.h"

@interface EditAboutTextController ()

@end

@implementation EditAboutTextController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = NSLocalizedString(@"О себе",@"");
    [self.textView becomeFirstResponder];
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 30, 44)];
    [editBtn setImage:[UIImage imageNamed:@"accept_ico"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(saveProfile) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)saveProfile
{
    if (self.textView.text.length>0)[self sendUpdateProfileRequest];
}

- (void)sendUpdateProfileRequest
{
   /* [[ApiManager new] updateProfile:[NSString stringWithFormat:@"%ld",(long)[UmkaUser profile]]
                             params:@{@"about":self.textView.text} completition:^(id response, NSError *error) {
                                 if (response[@"pic"])[UmkaUser saveUserAvatar:response[@"pic"]];
                                 if (response[@"name"])[UmkaUser saveUserName:response[@"name"]];
                                 if (response[@"phone"])[UmkaUser savePhone:response[@"phone"]];
                                 if (response[@"gender"])[UmkaUser saveGender:response[@"gender"]];
                                 if (response[@"email"])[UmkaUser saveUserEmail:response[@"email"]];
                                 if (response[@"about"])[UmkaUser saveAbout:response[@"about"]];
                                 [self showAlert];
                             }];*/
}

- (void)showAlert
{
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"Умка",@"")
                                          message:NSLocalizedString(@"Информация успешно обновлена",@"")
                                          preferredStyle:UIAlertControllerStyleAlert];
    
    
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"OK", @"OK action")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   [self.navigationController popViewControllerAnimated:YES];
                               }];
    [alertController addAction:okAction];
    [self presentViewController:alertController animated:YES completion:nil];
}

@end
