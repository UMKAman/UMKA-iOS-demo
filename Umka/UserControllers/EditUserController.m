//
//  EditUserController.m
//  Umka
//
//  Created by Ігор on 10.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "EditUserController.h"
#import "IZTextField.h"

@interface EditUserController ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) IZTextField *phoneField;
@property (nonatomic, strong) IZTextField *nameField;
@property (nonatomic, strong) IZTextField *aboutField;
@property (nonatomic, weak) IBOutlet UIButton *avatarBtn;
@property (nonatomic, strong) UIImage *selectedAvatar;
@property (nonatomic, strong) NSArray *fields;
@end

@implementation EditUserController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"";
    self.title = NSLocalizedString(@"Изменить профиль",@"");
    self.nameField = [self setupTextField:0 placeholder:NSLocalizedString(@"Имя", @"") keyboard:@"text"];
    [self.view addSubview:self.nameField];
    self.nameField.text = self.user.name;
    
    self.aboutField = [self setupTextField:1 placeholder:NSLocalizedString(@"О себе", @"") keyboard:@"text"];
    [self.view addSubview:self.aboutField];
    self.aboutField.text = self.user.about;
    
    self.phoneField = [self setupTextField:2 placeholder:NSLocalizedString(@"Телефон", @"") keyboard:@"numbers"];
    [self.view addSubview:self.phoneField];
    self.phoneField.text = self.user.phone;
    
    self.avatarBtn.layer.cornerRadius = 50.0;
    self.avatarBtn.clipsToBounds = YES;
    self.avatarBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self.avatarBtn sd_setImageWithURL:[NSURL URLWithString:self.user.pic] forState:UIControlStateNormal placeholderImage:self.avatarBtn.imageView.image];
    self.fields = @[self.nameField, self.phoneField,self.aboutField];
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 30, 44)];
    [editBtn setImage:[UIImage imageNamed:@"accept_ico"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(saveProfile) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = barItem;
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.topItem.title = NSLocalizedString(@"Профиль",@"");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IZTextField*)setupTextField:(NSInteger)index placeholder:(NSString*)placeholder keyboard:(NSString*)keyboard
{
    CGFloat w = [UIScreen mainScreen].bounds.size.width;
    IZTextField *textField =[[IZTextField alloc] initWithFrame:CGRectMake(8, 200+48*index, w-16, 26)];
    textField.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
    textField.autocorrectionType = UITextAutocorrectionTypeNo;
    textField.keyboardAppearance = UIKeyboardAppearanceDark;
    textField.textColor=[UIColor blackColor];
    textField.enableMaterialPlaceHolder=YES;
    textField.delegate = self;
    //textField.clearsOnBeginEditing = YES;
    textField.errorColor=[UIColor colorWithRed:0.910 green:0.329 blue:0.271 alpha:1.000]; // FLAT RED COLOR
    //textField.lineColor=[ApplicationSettings accentColor];
    textField.tintColor= [UIColor colorWithRed:63.0/255.0 green:81.0/255.0 blue:181.0/255.0 alpha:1.0];
    textField.placeholder=placeholder;
    if ([keyboard isEqualToString:@"email"])
    {
        textField.keyboardType = UIKeyboardTypeEmailAddress;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    if ([keyboard isEqualToString:@"numbers"])
    {
        textField.keyboardType = UIKeyboardTypePhonePad;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    if ([keyboard isEqualToString:@"password"])
    {
        textField.secureTextEntry = YES;
        textField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    }
    return textField;
}


- (IBAction)changeImage
{
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


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerOriginalImage];
    [self.avatarBtn setImage:image forState:UIControlStateNormal];
    self.selectedAvatar = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)saveProfile
{
    [self.view endEditing:YES];
    if (self.selectedAvatar)
    {
        [[ApiManager new] uploadImage:self.selectedAvatar userID:self.user.id completition:^(id response, NSError *error) {
            [self sendUpdateProfileRequest];
        }];
    }
    else [self sendUpdateProfileRequest];
}

- (void)sendUpdateProfileRequest{
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (self.phoneField.text.length>0)[params setObject:self.phoneField.text forKey:@"phone"];
    if (self.nameField.text.length>0)[params setObject:self.nameField.text forKey:@"name"];
    if (self.aboutField.text.length>0)[params setObject:self.aboutField.text forKey:@"about"];
    [[ApiManager new] updateUser:self.user.id
                             params:params completition:^(id response, NSError *error) {
                                 if (response){self.user = [self.user updateUser:response];
                                     [self showAlert];}
                             }];
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

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
