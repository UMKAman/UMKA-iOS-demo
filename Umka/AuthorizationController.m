//
//  AuthorizationController.m
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "AuthorizationController.h"
#import "Constants.h"
#import "ApiManager.h"
#import "AppDelegate.h"
#import "UmkaUser.h"
#import <CoreLocation/CoreLocation.h>
#import "SelectLocationOnMap1.h"
#import "PrivacyPolicy.h"

@interface AuthorizationController ()<UITextFieldDelegate,CLLocationManagerDelegate,LocationPickerDelegate>
@property (nonatomic,weak) IBOutlet UIPageControl *pageControl;
@property (nonatomic,weak) IBOutlet UIScrollView *scrollView;
@property (nonatomic,weak) IBOutlet UIButton *nextBtn;
@property (nonatomic,weak) IBOutlet UIButton *prevBtn;

@property (nonatomic, weak) IBOutlet UITextField *phoneField;
@property (nonatomic, weak) IBOutlet UITextField *passField;
@property (nonatomic, weak) IBOutlet UITextField *passField1;
@property (nonatomic, weak) IBOutlet UITextField *passField2;
@property (nonatomic, weak) IBOutlet UITextField *passField3;

@property (nonatomic, weak) IBOutlet UIButton *rememberMe;
@property (nonatomic, weak) IBOutlet UIButton *chooseCity;
@property (nonatomic, weak) IBOutlet UILabel *cityLabel;

@property (nonatomic, weak) IBOutlet UIImageView *userArrow;
@property (nonatomic, weak) IBOutlet UIImageView *masterArrow;

@property (nonatomic, weak) IBOutlet UILabel *labelTitle;
@property (nonatomic, weak) IBOutlet UILabel *labelSubtitle;
@property (nonatomic, weak) IBOutlet UILabel *labelSkipStep;

@property (nonatomic, weak) IBOutlet UILabel *helloLabel;
@property (nonatomic, weak) IBOutlet UILabel *chooseModeLabel;
@property (nonatomic, weak) IBOutlet UILabel *userModeLabel;
@property (nonatomic, weak) IBOutlet UILabel *userModeDescr;
@property (nonatomic, weak) IBOutlet UILabel *specModeLabel;
@property (nonatomic, weak) IBOutlet UILabel *specModeDescr;
@property (nonatomic, weak) IBOutlet UILabel *step1Info;
@property (nonatomic, weak) IBOutlet UILabel *step1Oferta;
@property (nonatomic, weak) IBOutlet UILabel *step2SMSInfo;

@property (nonatomic, weak) IBOutlet UILabel *step3Title;
@property (nonatomic, weak) IBOutlet UILabel *step3Subtitle;
@property (nonatomic, weak) IBOutlet UIButton *step3Remember;
@property (nonatomic, weak) IBOutlet UILabel *step4Title;
@property (nonatomic, weak) IBOutlet UILabel *step4Subtitle;
@property (nonatomic, weak) IBOutlet UIButton *beginBtn;
@property (nonatomic, strong) CLLocation *currentLocation;

@property (nonatomic, strong) CLLocationManager *locationManager;

@property (nonatomic, weak) IBOutlet UIView *v1;
@property (nonatomic, weak) IBOutlet UIView *v2;
@property (nonatomic, weak) IBOutlet UIView *v3;
@property (nonatomic, weak) IBOutlet UIView *v4;
@property (nonatomic, strong) NSString *code;
@property (nonatomic, strong) PrivacyPolicy *privacyPolicy;
@property (nonatomic, assign) BOOL isRegister;
@property (nonatomic, assign) BOOL isRestore;
@property (nonatomic, strong) NSString *restoreCode;
@end

@implementation AuthorizationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self refreshInfo:@""];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    //self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    
    self.prevBtn.hidden = YES;
    self.phoneField.keyboardType = UIKeyboardTypePhonePad;
    self.phoneField.delegate = self.passField.delegate = self.passField1.delegate = self.passField2.delegate = self.passField3.delegate = self;
    self.scrollView.contentSize = CGSizeMake(4*[UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.v1.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.v2.frame = CGRectMake([UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.v3.frame = CGRectMake(2*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    self.v4.frame = CGRectMake(3*[UIScreen mainScreen].bounds.size.width, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    
    self.userArrow.image = [self.userArrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.userArrow setTintColor:[UIColor whiteColor]];
    
    self.masterArrow.image = [self.masterArrow.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.masterArrow setTintColor:[UIColor whiteColor]];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
    self.helloLabel.text = NSLocalizedString(@"Привет!", @"");
    self.chooseModeLabel.text = NSLocalizedString(@"Выберите режим работы приложения:",@"");
    
    self.userModeLabel.text = NSLocalizedString(@"Пользователь",@"");
    self.userModeDescr.text = NSLocalizedString(@"Просматривайте предлагаемые услуги и анкеты специалистов. Авторизованные пользователи могут оставить отзывы.",@"");
    self.specModeLabel.text = NSLocalizedString(@"Специалист",@"");
    self.specModeDescr.text = NSLocalizedString(@"Создайте анкету и начните зарабатывать вместе с Умка!",@"");
    self.step1Info.text = NSLocalizedString(@"Вы всегда сможете переключиться с пользователя на специалиста и обратно в меню приложения.",@"");
    
    
    NSDictionary *underlineAttribute = @{NSUnderlineStyleAttributeName: @(NSUnderlineStyleSingle)};
    self.step1Oferta.attributedText = [[NSAttributedString alloc] initWithString:NSLocalizedString(@"Продолжая, Вы соглашаетесь с правилами использования и офертой об использовании личных данных",@"")
                                                             attributes:underlineAttribute];
    //self.step1Oferta.text = NSLocalizedString(@"Продолжая, Вы соглашаетесь с правилами использования и офертой об использовании личных данных",@"");
    
    [self.nextBtn setTitle:NSLocalizedString(@"ДАЛЕЕ", @"") forState:UIControlStateNormal];
    [self.prevBtn setTitle:NSLocalizedString(@"НАЗАД", @"") forState:UIControlStateNormal];
    
    self.labelSkipStep.text = NSLocalizedString(@"Вы можете пропустить этот шаг и вернуться к нему позднее.",@"");
    self.step2SMSInfo.text = NSLocalizedString(@"На этот номер будет отправлено смс с паролем.",@"");
    
    self.step3Title.text = NSLocalizedString(@"Почти готово",@"");
    self.step3Subtitle.text = NSLocalizedString(@"Придумайте пароль для входа в систему",@"");
    self.cityLabel.alpha = 0.0;
    [self.rememberMe setTitle:NSLocalizedString(@"Восстановить пароль",@"") forState:UIControlStateNormal];
    [self.chooseCity setTitle:NSLocalizedString(@"Выберите город",@"") forState:UIControlStateNormal];
    self.chooseCity.titleEdgeInsets = UIEdgeInsetsMake(0, -self.chooseCity.imageView.frame.size.width, 0, self.chooseCity.imageView.frame.size.width);
    self.chooseCity.imageEdgeInsets = UIEdgeInsetsMake(0, self.chooseCity.titleLabel.frame.size.width, 0, -self.chooseCity.titleLabel.frame.size.width);
    
    self.step4Title.text = NSLocalizedString(@"Все готово!",@"");
    self.step4Subtitle.text = NSLocalizedString(@"Добро пожаловать\nв мир услуг Умка!",@"");
    [self.beginBtn setTitle:NSLocalizedString(@"НАЧАТЬ",@"") forState:UIControlStateNormal];
}

- (void)updateFrameForView:(UIView*)view
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextAction:(id)sender
{
    if (self.pageControl.currentPage==0)
    {
        [self showAlert:NSLocalizedString(@"Сначала выберите режим работы приложения",@"")];
    }
    else if (self.pageControl.currentPage==1)
    {
        BOOL vp = [self validatePhone:self.phoneField.text];
        if (vp)
        {
            NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@"(" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
            phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [[ApiManager new] checkPhone:@{@"phone":phone} completition:^(NSDictionary *object, NSError *error) {
                self.isRegister = [object[@"result"] boolValue];
                self.step3Subtitle.text =(!self.isRegister)? NSLocalizedString(@"Придумайте пароль для входа в систему",@""):NSLocalizedString(@"Введите ваш пароль",@"");
                self.pageControl.currentPage = 2;
                [self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*(self.pageControl.currentPage), 0) animated:YES];
            }];
        }
        else
        {
            [self showAlert:NSLocalizedString(@"Пожалуйста, укажите реальный номер телефона для работы оповещений и взаимодействия с другими пользователями",@"")];
        }
    }
    else if (self.pageControl.currentPage==2)
    {
        if (self.isRestore){
            if (self.restoreCode.length==0){
                self.restoreCode = [NSString stringWithFormat:@"%@%@%@%@",self.passField.text,self.passField1.text,self.passField2.text,self.passField3.text];
                if (![self.restoreCode isEqualToString:self.code])
                {
                    self.restoreCode = @"";
                    self.passField.text = self.passField1.text = self.passField2.text = self.passField3.text = @"";
                    [self.passField becomeFirstResponder];
                    [self showAlert:NSLocalizedString(@"Введите код подтверждения, полученный\nв смс-сообщении",@"")];
                }
                else
                {
                    self.passField.text = self.passField1.text = self.passField2.text = self.passField3.text = @"";
                    [self.passField becomeFirstResponder];
                    self.step3Subtitle.text = NSLocalizedString(@"Придумайте новый пароль для входа в систему",@"");
                    [self showAlert:NSLocalizedString(@"Придумайте новый пароль для входа в систему",@"")];
                }
            }
            else [self resetRequest];
        }
        else {
        if (!self.isRegister)[self registrationRequest];
        else [self authRequest];
        }
    }
}

- (void)authRequest{
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [[ApiManager new] sendPhonePIN:@{@"phone":phone,@"password":[NSString stringWithFormat:@"%@%@%@%@",self.passField.text,self.passField1.text,self.passField2.text,self.passField3.text],@"device":@"ios device",@"fireToken":[UmkaUser fireToken]} completition:^(NSDictionary *jsonObject, NSError *error){
        if (jsonObject)[self loginDidSuccess:jsonObject];
        else [self showAlert:NSLocalizedString(@"Неверный пароль",@"")];
        self.passField.text = self.passField1.text = self.passField2.text = self.passField3.text = @"";
    }];
}

- (void)registrationRequest{
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *password = [NSString stringWithFormat:@"%@%@%@%@",self.passField.text,self.passField1.text,self.passField2.text,self.passField3.text];
    [[ApiManager new] registration:@{@"phone":phone,
                                     @"password":password,
                                     @"device":@"ios device",
                                     @"fireToken":[UmkaUser fireToken]} completition:^(NSDictionary *object, NSError *error) {
                                         if (!error)[self loginDidSuccess:object];
                                         else {
                                             //[self showAlert:NSLocalizedString(@"Пользователь с таким номером уже зарегистрирован в нашей системе",@"")];
                                             [self authRequest];
                                         }
                                     }];
}

- (void)resetRequest{
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    NSString *password = [NSString stringWithFormat:@"%@%@%@%@",self.passField.text,self.passField1.text,self.passField2.text,self.passField3.text];
    if (password.length>0){
        [[ApiManager new] resetPassword:@{@"phone":phone,@"password":password,@"code":self.restoreCode,@"device":@"ios device",@"fireToken":[UmkaUser fireToken]} completition:^(NSDictionary *object, NSError *error) {
            if (!error)[self loginDidSuccess:object];
            else [self showAlert:NSLocalizedString(@"Неверный пароль",@"")];
        }];
    }
    else [self showAlert:NSLocalizedString(@"Придумайте новый пароль для входа в систему",@"")];
}

-(IBAction)resetPassword:(id)sender{
    NSString *phone = [self.phoneField.text stringByReplacingOccurrencesOfString:@"(" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@")" withString:@""];
    phone = [phone stringByReplacingOccurrencesOfString:@"-" withString:@""];
    [[ApiManager new] remindPassword:@{@"phone":phone} completition:^(NSDictionary *object, NSError *error) {
        NSLog(@"%@",object);
        self.code = object[@"code"];
        self.isRestore = YES;
        self.restoreCode = @"";
        self.step3Subtitle.text = NSLocalizedString(@"Введите код подтверждения, полученный\nв смс-сообщении",@"");
        [self showAlert:NSLocalizedString(@"Код подтверждения отправлен на указанный вами номер. Введите этот код и нажмите \"ДАЛЕЕ\"",@"")];
        [SVProgressHUD showInfoWithStatus:object[@"code"]];
        [self.passField becomeFirstResponder];
    }];
}

- (void)loginDidSuccess:(id)jsonObject{
    [UmkaUser saveAccessToken:jsonObject[@"jwt"]];
    [UmkaUser saveUserProfile:[jsonObject[@"user"][@"id"] integerValue]];
    [UmkaUser savePhone:jsonObject[@"user"][@"phone"]];
    [UmkaUser saveUserID:[jsonObject[@"user"][@"id"] integerValue]];
    
    NSString *appMode = [UmkaUser appMode];
    BOOL is_master = ([appMode isEqualToString:@"master"])?YES:NO;
    [[ApiManager new] updateUser:[NSNumber numberWithInteger:[UmkaUser userID]] params:@{@"isMaster":[NSNumber numberWithBool:is_master]} completition:^(id response, NSError *error) {
        if ([appMode isEqualToString:@"master"])[self findOrCreateMaster];
        [self.pageControl removeFromSuperview];
        [self.nextBtn removeFromSuperview];
        [self.prevBtn removeFromSuperview];
        [self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*(self.pageControl.currentPage+1), 0) animated:YES];
    }];
}

- (void)findOrCreateMaster{
    __block MasterModel *master;
    [[ApiManager new] getAllMastersCompletition:^(id response, NSError *error) {
        for (NSDictionary *dict in response){
            MasterModel *model = [[MasterModel alloc] initWithDictionary:dict];
            if (model.user.id.integerValue==[UmkaUser userID]){
                master = model;
                [UmkaUser saveMasterID:master.id.integerValue];
                
                break;
            }
        }
        if (!master){
            [[ApiManager new] createMasterCompletition:^(id response, NSError *error) {
                [UmkaUser saveMasterID:[response[@"id"] integerValue]];
            }];
        }
    }];
}

- (IBAction)backAction:(id)sender
{
    [self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*(self.pageControl.currentPage-1), 0) animated:YES];
    if (self.pageControl.currentPage==2)
    {
        self.pageControl.currentPage = 1;
    }
    else if (self.pageControl.currentPage==1)
    {
        self.prevBtn.hidden =  YES;
        self.pageControl.currentPage = 0;
    }
}

- (IBAction)chooseAppMode:(UIButton*)btn
{
    NSString *mode = (btn.tag==0)?@"user":@"master";
    
    if ([mode isEqualToString:@"user"])
    {
        self.labelTitle.text = NSLocalizedString(@"Выбран режим\nпользователя",@"");
        self.labelSubtitle.text = NSLocalizedString(@"Авторизуйтесь и получите доступ\nко всем функциям приложения",@"");
        self.labelSkipStep.alpha = 1.0;
    }
    else
    {
        self.labelTitle.text = NSLocalizedString(@"Выбран режим\nспециалиста",@"");
        self.labelSubtitle.text = NSLocalizedString(@"Авторизуйтесь и начните\nзарабатывать вместе с Умка!",@"");
        self.labelSkipStep.alpha = 0.0;
    }
    
    [self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*1, 0) animated:YES];
    [UmkaUser saveAppMode:mode];
    self.prevBtn.hidden = self.nextBtn.hidden = NO;
    self.pageControl.currentPage = 1;
}

- (IBAction)startApp:(id)sender
{
    [[AppDelegate sharedDelegate] showMainMenu];
}


- (void)showAlert:(NSString*)message
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Умка",@"")
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"")
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
    {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark ---------------------
#pragma mark Text Field Delegates


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([textField isEqual:self.phoneField])
    {
        if (string.length>0)
        {
            if ((textField.text.length>0 || (textField.text.length==0 && ![string isEqualToString:@"+"])) && ![textField.text hasPrefix:@"+"])
            {
                textField.text = [NSString stringWithFormat:@"+%@",textField.text];
            }
            if (textField.text.length==5)
            {
                textField.text = [NSString stringWithFormat:@"%@(%@)",[textField.text substringToIndex:2],[textField.text substringFromIndex:2]];
            }
            if (textField.text.length==10)
            {
                textField.text = [NSString stringWithFormat:@"%@-",textField.text];
            }
            if (textField.text.length==14)
            {
                textField.text = [NSString stringWithFormat:@"%@%@",textField.text, string];
                [textField resignFirstResponder];
                return NO;
            }
        }
        else
        {
            if (textField.text.length<8)
            {
                textField.text = [textField.text stringByReplacingOccurrencesOfString:@"(" withString:@""];
                textField.text = [textField.text stringByReplacingOccurrencesOfString:@")" withString:@""];
            }
        }
        //+7(922)555-1234
    }
    else
    {
        if (textField.text.length==0)
        {
            if ([textField isEqual:self.passField])
            {
                textField.text = string;
                [self.passField1 becomeFirstResponder];
                return NO;
            }
            else if ([textField isEqual:self.passField1])
            {
                textField.text = string;
                [self.passField2 becomeFirstResponder];
                return NO;
            }
            else if ([textField isEqual:self.passField2])
            {
                textField.text = string;
                [self.passField3 becomeFirstResponder];
                return NO;
            }
            else if ([textField isEqual:self.passField3])
            {
                textField.text = string;
                [self.passField3 resignFirstResponder];
                return NO;
            }
        }
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textField.text=@"";
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)validatePhone:(NSString *)phoneNumber
{
    return phoneNumber.length==15 && [phoneNumber hasPrefix:@"+7"];
}


#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    /* UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Умка" message:@"Не могу определить Ваше метоположение" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];*/
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    if (self.currentLocation!=newLocation)
    {
    self.currentLocation = newLocation;
        [self.locationManager stopUpdatingLocation];
    if (self.currentLocation != nil) {
        CLGeocoder *geocoder = [[CLGeocoder alloc] init];
        [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
            NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
            if (error == nil && [placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks lastObject];
                if (placemark.locality)
                {
                    NSString *latitude =[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
                    NSString *longitude =[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
                    NSDictionary *dict = @{@"latitude":latitude,@"longitude":longitude,@"city":placemark.locality};
                    [UmkaUser saveUserLocation:dict];
                    [self refreshInfo:placemark.locality];
                }
                else
                {
                }
            } else {
                NSLog(@"%@", error.debugDescription);
            }
        } ];
    }
    }
}

- (NSAttributedString*)attrString:(NSString*)city
{
    NSString *ls = [NSString stringWithFormat:NSLocalizedString(@"Ваш город определен автоматически %@. Вы можете выбрать нужный город самостоятельно:",@""),city];
    NSMutableAttributedString *attributedString =[[NSMutableAttributedString alloc] initWithString:ls];
    
    [attributedString addAttribute:NSForegroundColorAttributeName
                             value:[UIColor whiteColor]
                             range:[ls rangeOfString:city]];
    return attributedString;
}

- (IBAction)chooseCityAction
{
    SelectLocationOnMap1 *vc =  [[SelectLocationOnMap1 alloc] init];
    vc.delegate = self;
    
    
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:vc];
    UIColor *color = [UIColor colorWithRed:63.0/255.0 green:81.0/255.0 blue:181.0/255.0 alpha:1.0];
    nc.navigationBar.barTintColor = color;
    nc.navigationBar.tintColor = [UIColor whiteColor];
    
    [self presentViewController:nc animated:YES completion:nil];
}

- (void)refreshInfo:(NSString*)city
{
    self.cityLabel.alpha = 1.0;
    self.cityLabel.attributedText = [self attrString:city];
    [self.chooseCity setTitle:city forState:UIControlStateNormal];
    
    self.chooseCity.titleEdgeInsets = UIEdgeInsetsMake(0, -self.chooseCity.imageView.frame.size.width, 0, self.chooseCity.imageView.frame.size.width);
    self.chooseCity.imageEdgeInsets = UIEdgeInsetsMake(0, self.chooseCity.titleLabel.frame.size.width, 0, -self.chooseCity.titleLabel.frame.size.width);
}

- (void)updateScrollView
{
    [self.scrollView setContentOffset:CGPointMake([UIScreen mainScreen].bounds.size.width*2, 0) animated:NO];
}

- (void)picker:(SelectLocationOnMap1 *)picker didChooseLocation:(NSString *)city{
    [self refreshInfo:city];
    [self updateScrollView];
}


-(IBAction)showPrivacyPolicy:(id)sender{
    self.privacyPolicy = [[PrivacyPolicy alloc] init];
    UINavigationController  *nc = [[UINavigationController alloc] initWithRootViewController:self.privacyPolicy];
    nc.navigationBar.barTintColor = [UIColor colorWithRed:24.0/255.0 green:31.0/255.0 blue:57.0/255.0 alpha:1.0];
    nc.navigationBar.tintColor = [UIColor whiteColor];
    nc.navigationBar.translucent = NO;
    [self presentViewController:nc animated:YES completion:nil];
}
@end
