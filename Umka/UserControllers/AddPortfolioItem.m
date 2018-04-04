//
//  AddPortfolioItem.m
//  Umka
//
//  Created by Igor Zalisky on 12/29/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "AddPortfolioItem.h"
#import "CategoryModel.h"
#import "FilterSpecPicker.h"
#import "ApiManager.h"
#import "UmkaUser.h"

@interface AddPortfolioItem ()<UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) CategoryModel *category;
@property (nonatomic, strong) NSString *service_description;
@property (nonatomic, strong) UIImage *selectedImage;
@end

@implementation AddPortfolioItem

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section==0)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ImageCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"ImageCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (self.selectedImage)
        {
            UIImageView *img = [cell.contentView viewWithTag:88];
            img.image = self.selectedImage;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.textLabel.text = @"";
        }
        else
        {
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.textLabel.text = NSLocalizedString(@"Добавьте изображение",@"");
        }
        return cell;
    }
    else if (indexPath.section==1)
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"LabelCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"LabelCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UILabel *lbl = [cell.contentView viewWithTag:88];
        lbl.text = (self.category)?self.category.name:NSLocalizedString(@"Не выбрано",@"");
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"TextFieldCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField *lbl = [cell.contentView viewWithTag:88];
        lbl.tag = indexPath.section;
        if (indexPath.section==2)
        {
            lbl.text = self.service_description;
            lbl.placeholder = NSLocalizedString(@"Описание работы",@"");
        }
        return cell;
    }
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) return NSLocalizedString(@"Выберите изображение",@"");
    else if (section==1) return NSLocalizedString(@"Выберите специальность",@"");
    return  NSLocalizedString(@"Описание работы",@"");
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, tableView.frame.size.width-30, 18)];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Meduim" size:16]];
    NSString *string = nil;
    if (section==0) string = NSLocalizedString(@"Выберите изображение",@"");
    else if (section==1) string = NSLocalizedString(@"Выберите специальность",@"");
    else string = NSLocalizedString(@"Описание работы",@"");
    [label setText:string];
    label.textColor = [UIColor darkGrayColor];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor colorWithWhite:0.97 alpha:1.0]];
    return view;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.text.length>0)
    {
        if (textField.tag==2)
        {
            self.service_description = textField.text;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!self.selectedImage) return 44;
    else return (indexPath.section==0)?200:44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        FilterSpecPicker *picker = [self.storyboard instantiateViewControllerWithIdentifier:@"FilterSpecPicker"];
        picker.delegate = self;
        [self.navigationController pushViewController:picker animated:YES];
    }
    else if (indexPath.section==0)
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
    self.selectedImage = image;
    [self.tableView reloadData];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)selectCategory:(NSDictionary*)dict
{
    self.category = [[CategoryModel alloc] initWithDictionary:dict];
    [[self tableView] reloadData];
}

- (void)saveProfile
{
    [self.view endEditing:YES];
    NSString *alertMessage = @"";
    if (!self.category) alertMessage = NSLocalizedString(@"Сначала нужно выбрать специальность",@"");
    else if (!self.service_description ||self.service_description.length==0)self.service_description = @"";
    else if (!self.selectedImage)alertMessage = NSLocalizedString(@"Нужно добавить изображение работы",@"");
    if (alertMessage.length>0)[self showAlert:alertMessage];
    else
    {
#warning add portfolio method 
        /*
        [[ApiManager new] addPortfolio:@{@"description":self.service_description,
                                     @"servicelayer":self.category.category_layer,
                                     @"serviceoneid":self.category.category_one_id} image:self.selectedImage
                          completition:^(id response, NSError *error) {
                                         NSLog(@"%@",response);
                                         [self.navigationController popViewControllerAnimated:YES];
                                         
                                     }];*/
    }
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

@end
