//
//  CreateService.m
//  Umka
//
//  Created by Igor Zalisky on 12/28/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "CreateService.h"
#import "CategoryModel.h"
#import "FilterSpecPicker.h"
#import "ApiManager.h"
#import "UmkaUser.h"

@interface CreateService ()<UITextFieldDelegate>
@property (nonatomic, strong) Service *service;
@end

@implementation CreateService

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    UIButton *editBtn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 30, 44)];
    [editBtn setImage:[UIImage imageNamed:@"navbar_save"] forState:UIControlStateNormal];
    [editBtn addTarget:self action:@selector(saveProfile) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:editBtn];
    self.navigationItem.rightBarButtonItem = barItem;
    self.service = [Service new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextFieldCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                          reuseIdentifier:@"TextFieldCell"];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UITextField *lbl = [cell.contentView viewWithTag:88];
        lbl.tag = indexPath.section;
        if (indexPath.section==1)
        {
            lbl.text =([self.service.cost isKindOfClass:[NSNull class]])?[NSString stringWithFormat:@"%@",self.service.cost]:@"";
            lbl.placeholder = NSLocalizedString(@"Укажите цену, целое число",@"");
            lbl.keyboardType = UIKeyboardTypeDecimalPad;
        }
        else if (indexPath.section==2)
        {
            lbl.text =self.service.currency;
            lbl.placeholder = NSLocalizedString(@"Укажите валюту, напр. ₽, $, €, ₴ и т.п.",@"");
            lbl.keyboardType = UIKeyboardTypeASCIICapable;
        }
        else if (indexPath.section==3)
        {
            lbl.text =([self.service.count isKindOfClass:[NSNull class]])?[NSString stringWithFormat:@"%@",self.service.count]:@"";
            lbl.placeholder = NSLocalizedString(@"Укажите количество, целое число",@"");
            lbl.keyboardType = UIKeyboardTypeDecimalPad;
        }
        else if (indexPath.section==4)
        {
            lbl.text = self.service.measure;
            lbl.placeholder = NSLocalizedString(@"напр. часы, минуты, м², км и т.п.",@"");
        }
        else if (indexPath.section==0)
        {
            lbl.text = self.service.name;
            lbl.placeholder = NSLocalizedString(@"напр. Покраска стен, Дизайн интерьера",@"");
        }
        return cell;
}


- (NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section==0) return NSLocalizedString(@"Название услуги",@"");
    else if (section==1) return  NSLocalizedString(@"Цена услуги",@"");
    else if (section==2) return  NSLocalizedString(@"Валюта",@"");
    else if (section==3) return  NSLocalizedString(@"Количество",@"");
    else return NSLocalizedString(@"Единица измерения",@"");
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 18)];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, tableView.frame.size.width-30, 18)];
    [label setFont:[UIFont fontWithName:@"HelveticaNeue-Meduim" size:16]];
    NSString *string = nil;
    if (section==0) string = NSLocalizedString(@"Описание услуги",@"");
    else if (section==1) string =  NSLocalizedString(@"Цена услуги",@"");
    else if (section==2) string =  NSLocalizedString(@"Валюта",@"");
    else if (section==3) string =  NSLocalizedString(@"Количество",@"");
    else string = NSLocalizedString(@"Единица измерения",@"");
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
    if (textField.text.length>0){
        if (textField.tag==0)self.service.name = textField.text;
        else if (textField.tag==1)self.service.cost = [NSNumber numberWithInteger:textField.text.integerValue];
        else if (textField.tag==2)self.service.currency = textField.text;
        else if (textField.tag==3) self.service.count = [NSNumber numberWithInteger:textField.text.integerValue];
        else if (textField.tag==4) self.service.measure = textField.text;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (void)saveProfile{
    [self.view endEditing:YES];
    NSString *alertMessage = @"";
    if (!self.service.name ||self.service.name.length==0)alertMessage = NSLocalizedString(@"Нужно указать название услуги",@"");
    else if (!self.service.cost ||self.service.cost.integerValue<=0)alertMessage = NSLocalizedString(@"Нужно указать цену услуги",@"");
    else if (!self.service.currency ||self.service.currency.length==0)alertMessage = NSLocalizedString(@"Нужно указать валюту",@"");
    else if (!self.service.count ||self.service.count.integerValue<=0)alertMessage = NSLocalizedString(@"Нужно указать количество",@"");
    else if (!self.service.measure ||self.service.measure.length==0)alertMessage = NSLocalizedString(@"Нужно указать еденицу измерения",@"");
    if (alertMessage.length>0)[self showAlert:alertMessage];
    else
    {
        NSDictionary *params = @{@"name":self.service.name,
                                 @"cost":self.service.cost,
                                 @"currency":self.service.currency,
                                 @"count":self.service.count,
                                 @"measure":self.service.measure};
        [[ApiManager new] addService:params completition:^(id response, NSError *error) {
            [self.delegate serviceDidCreated:self.service];
            [self.navigationController popViewControllerAnimated:YES];
        }];
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
