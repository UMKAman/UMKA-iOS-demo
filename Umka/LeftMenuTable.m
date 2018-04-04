//
//  AMMenuTableViewController.m
//  AdWithMe
//
//  Created by Eugene Kuropatenko on 21.11.15.
//  Copyright © 2015 AdWithMe. All rights reserved.
//

#import "LeftMenuTable.h"
#import "AppDelegate.h"
#import "LeftMenuController.h"
#import "MenuCell.h"
#import "Constants.h"
#import "UmkaUser.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ApiManager.h"

#import "SelectLocationOnMap.h"
#import "UserProfileController.h"
#import "UserFavoritesController.h"
#import "AccountController.h"
#import "PremiumController.h"
#import <MessageUI/MessageUI.h>

@interface LeftMenuTable ()<LocationPickerDelegate,MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) NSArray *titlesArray;
@property (strong, nonatomic) NSArray *iconsArray;
@property (strong, nonatomic) UserModel *user;
@end

@implementation LeftMenuTable

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadMainMenu) name:K_RELOAD_MAIN_MENU object:nil];
    [self reloadMainMenu];
    [self viewProfile];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0.f, 0.f, 0.f, 0.f);
    
    self.tableView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.1];
    self.tableView.opaque = NO;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"menu_bg"]];
    self.clearsSelectionOnViewWillAppear = NO;
    [self.tableView reloadData];
}

- (void)reloadMainMenu
{
    if (self.user.id!=nil){
    if ([UmkaUser isUser]){
        _iconsArray = @[@"",@"ic_side_nav_main",@"ic_side_nav_profile",@"ic_side_nav_rating",@"ic_side_nav_history",@"ic_side_nav_settings",@"ic_side_nav_feedback",@"ic_side_nav_location",@""];
        _titlesArray = @[(self.user.name)?self.user.name:NSLocalizedString(@"Пользователь",@""),
                         NSLocalizedString(@"Главная", nil),
                         NSLocalizedString(@"Профиль", nil),
                         NSLocalizedString(@"Избранное", nil),
                         NSLocalizedString(@"История заказов", nil),
                         NSLocalizedString(@"Настройки", nil),
                         NSLocalizedString(@"Обратная связь", nil),
                         (self.user.city.length>0)?self.user.city:NSLocalizedString(@"Выберите город", @""),
                         NSLocalizedString(@"Специалист", nil),
                         ];
    }
    else
    {
        _iconsArray = @[@"",@"ic_side_nav_main",@"ic_side_nav_profile",@"ic_side_nav_rating_",@"ic_side_nav_settings",@"ic_side_nav_feedback",@"ic_side_nav_location",@""];
        _titlesArray = @[(self.user.name)?self.user.name:NSLocalizedString(@"Специалист",@""),
                         NSLocalizedString(@"Главная", nil),
                         NSLocalizedString(@"Профиль", nil),
                         NSLocalizedString(@"Рейтинг и отзывы", nil),
                         NSLocalizedString(@"Настройки", nil),
                         NSLocalizedString(@"Обратная связь", nil),
                         (self.user.city.length>0)?self.user.city:NSLocalizedString(@"Выберите город", @""),
                         NSLocalizedString(@"Специалист", nil),
                         ];
    }
    [self.tableView reloadData];
    }
}

- (void)selectRootController
{
    NSString *appMode =[UmkaUser appMode];
    if ([appMode isEqualToString:@"user"])
    {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UmkaTabbarController"];
        [kNavigationController setViewControllers:@[vc]];
    }
    else
    {
        UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UmkaMasterTabbarController"];
        [kNavigationController setViewControllers:@[vc]];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [UmkaUser isUser]?_titlesArray.count:_titlesArray.count+1;
}

#pragma mark - UITableView Delegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row==0)
    {
        
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProfileMenuCell"];
        if (!cell) {
            cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"ProfileMenuCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.menuTitle.text = _titlesArray[indexPath.row];
        if ([UmkaUser isUser])cell.menuSubTitle.text = NSLocalizedString(@"Пользователь",@"");
        else cell.menuSubTitle.text = NSLocalizedString(@"Специалист",@"");
        //cell.menuIcon.image = [UIImage imageNamed:_iconsArray[indexPath.row]];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.menuTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14*SCALE_COOF];
        cell.menuSubTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12*SCALE_COOF];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
        {
            cell.menuTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:24];
            cell.menuSubTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
        }
        if (self.user.pic!=nil)
        {
            [cell.menuIcon sd_setImageWithURL:[NSURL URLWithString:self.user.pic] placeholderImage:[UIImage imageNamed:@"side_nav_no_avatar"]];
            cell.menuIcon.layer.cornerRadius = cell.menuIcon.frame.size.height/2.0;
        }
        
        return cell;
    }
    else if (indexPath.row>0 && indexPath.row<self.iconsArray.count-1)
    {
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenuCell"];
        if (!cell) {
            cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"MenuCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.menuTitle.text = _titlesArray[indexPath.row];
        cell.menuIcon.image = [UIImage imageNamed:_iconsArray[indexPath.row]];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.menuTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12*SCALE_COOF];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)cell.menuTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
        return cell;
    }
    else if (indexPath.row==self.iconsArray.count-1)
    {
        MenuCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UserMenuCell"];
        if (!cell) {
            cell = [[MenuCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"UserMenuCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.menuTitle.text = _titlesArray[indexPath.row];
        cell.menuIcon.image = [UIImage imageNamed:_iconsArray[indexPath.row]];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.menuTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:12*SCALE_COOF];
        if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)cell.menuTitle.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:20];
        NSString *appMode = [UmkaUser appMode];
        cell.modeSwitch.on = ![appMode isEqualToString:@"user"];
        cell.delegate = self;
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PremiumMenuCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                   reuseIdentifier:@"PremiumMenuCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        UIView *v = [cell.contentView viewWithTag:33];
        v.frame = CGRectMake(0.0, 0.0, [UIScreen mainScreen].bounds.size.width*0.75, cell.frame.size.height);
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        UILabel*lbl = [cell.contentView viewWithTag:333];
        lbl.text = NSLocalizedString(@"УВЕЛИЧЬТЕ КОЛИЧЕСТВО ЗАКАЗОВ\nС ПРЕМИУМ-АККАУНТОМ", @"");
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (UI_USER_INTERFACE_IDIOM()==UIUserInterfaceIdiomPad)
    {
        if (indexPath.row == 0)return 180.f;
        else if (indexPath.row==self.iconsArray.count) return 70;
        else return 80;
    }
    else if ([UIScreen mainScreen].bounds.size.height==480)
    {
        if (indexPath.row == 0) return 140.f;
        else if (indexPath.row==self.iconsArray.count) return 60;
        else return 31.f;
    }
    else
    {
        if (indexPath.row == 0)return 160.f*SCALE_COOF;
        else if (indexPath.row==self.iconsArray.count) return 70;
        else return 36.f*SCALE_COOF;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSString *appMode = [UmkaUser appMode];
    //if ([appMode isEqualToString:@"master"] && row>0)row = row+1;
    switch (row) {
        case 0: {
            /*AccountController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountController"];
            vc.user = self.user;
            [kNavigationController setViewControllers:@[vc]];
            [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];*/
        }
            break;
        case 1: {
            if ([appMode isEqualToString:@"master"]){
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UmkaMasterTabbarController"];
                [kNavigationController setViewControllers:@[vc]];
                [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
            }
            else {
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UmkaTabbarController"];
                [kNavigationController setViewControllers:@[vc]];
                [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
            }
        }
            break;
        case 2: {
            AccountController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountController"];
            vc.user = self.user;
            [kNavigationController setViewControllers:@[vc]];
            [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
        }
            break;
        case 3: {
            if ([appMode isEqualToString:@"master"]){
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserRatingAndReviewsController"];
                [kNavigationController setViewControllers:@[vc]];
                [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
            }
            else {
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserFavoritesController"];
                [kNavigationController setViewControllers:@[vc]];
                [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
            }
        }
            break;
        case 4:
        {
            if ([UmkaUser isUser]){
                UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserOrdersHistory"];
                [kNavigationController setViewControllers:@[vc]];
                [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
            }
            else [self openSettings];
        }
            break;
        case 5: {

            if ([UmkaUser isUser])[self openSettings];
            else [self feedBack];
            
        }
            break;
        case 6: {
            if ([UmkaUser isUser])[self feedBack];
            else [self selectLocation];
        }
            break;
        case 7: {
            if ([UmkaUser isUser])[self selectLocation];
        }
            break;
        case 8: {
            if (![UmkaUser isUser])[self premiumFunctions];
        }
            break;
            
        default:
            break;
    }
}

- (void)openSettings{
    UIViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"UserSettings"];
    [kNavigationController setViewControllers:@[vc]];
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
}

- (void)selectLocation{
    SelectLocationOnMap *vc =  [[SelectLocationOnMap alloc] init];
    vc.delegate = self;
    vc.address = self.user.city;
    [kNavigationController setViewControllers:@[vc]];
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
}

- (void)feedBack{
    UIAlertController * view=   [UIAlertController
                                 alertControllerWithTitle:nil
                                 message:nil
                                 preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* ideas = [UIAlertAction
                            actionWithTitle:NSLocalizedString(@"Предложения по улучшению",@"")
                            style:UIAlertActionStyleDefault
                            handler:^(UIAlertAction * action)
                            {
                                [view dismissViewControllerAnimated:YES completion:nil];
                                [self sendMailToRecepient:@"info@umka.city" subject:NSLocalizedString(@"Предложения по улучшению сервиса",@"")];
                            }];
    UIAlertAction* support = [UIAlertAction
                              actionWithTitle:NSLocalizedString(@"Техподдержка",@"")
                              style:UIAlertActionStyleDefault
                              handler:^(UIAlertAction * action)
                              {
                                  [view dismissViewControllerAnimated:YES completion:nil];
                                  [self sendMailToRecepient:@"admin@umka.city" subject:NSLocalizedString(@"Техподдержка",@"")];
                              }];
    
    UIAlertAction* cancel = [UIAlertAction
                             actionWithTitle:NSLocalizedString(@"Закрыть",@"")
                             style:UIAlertActionStyleCancel
                             handler:^(UIAlertAction * action)
                             {
                                 [view dismissViewControllerAnimated:YES completion:nil];
                             }];
    
    
    [view addAction:ideas];
    [view addAction:support];
    [view addAction:cancel];
    [kNavigationController presentViewController:view animated:YES completion:nil];
}

- (void)premiumFunctions{
    PremiumController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PremiumController"];
    [kNavigationController setViewControllers:@[vc]];
    [kMainViewController hideLeftViewAnimated:YES completionHandler:nil];
}


- (void)viewProfile
{
    [[ApiManager new] viewProfile:[NSString stringWithFormat:@"%ld",(long)[UmkaUser profile]] completition:^(id response, NSError *error) {
        self.user = [[UserModel alloc] initWithDictionary:response];
         [self reloadMainMenu];
    }];
}


- (void)picker:(SelectLocationOnMap *)picker didChooseLocation:(NSDictionary*)placemark{
    //[self viewProfile];
    [[ApiManager new] updateUser:[NSNumber numberWithInteger:[UmkaUser userID]] params:@{@"city":placemark[@"city"]} completition:^(id response, NSError *error) {
        [self viewProfile];
    }];
}

- (void)sendMailToRecepient:(NSString*)recepient subject:(NSString*)subject
{
    NSString *emailTitle = subject;
    // Email Content
    NSString *messageBody = @"";
    // To address
    NSArray *toRecipents = [NSArray arrayWithObject:recepient];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    [mc setToRecipients:toRecipents];
    
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
        {
            UIAlertController * view=   [UIAlertController
                                         alertControllerWithTitle:NSLocalizedString(@"Умка",@"")
                                         message:NSLocalizedString(@"Сообщение отправлено!",@"")
                                         preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:NSLocalizedString(@"ОК",@"")
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     //Do some thing here
                                     [view dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            [view addAction:ok];
            [self presentViewController:view animated:YES completion:nil];
        }
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}


@end
