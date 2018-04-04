//
//  PrivacyPolicy.m
//  Umka
//
//  Created by Ігор on 05.10.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "PrivacyPolicy.h"

@interface PrivacyPolicy ()
@end

@implementation PrivacyPolicy

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    
    NSURL *targetURL = [[NSBundle mainBundle] URLForResource:@"PrivacyPolicy" withExtension:@"pdf"];
    NSURLRequest *request = [NSURLRequest requestWithURL:targetURL];
    [webView loadRequest:request];
    
    [self.view addSubview:webView];
    
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 44, 44)];
    [doneBtn setTitle:NSLocalizedString(@"Готово", @"") forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(doneAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    self.navigationItem.leftBarButtonItem = barItem;
}

- (void)doneAction{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
