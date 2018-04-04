//
//  AccountInfoCell.m
//  Umka
//
//  Created by Ігор on 25.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountInfoCell.h"
#import "SelectLocationOnMap.h"
#import <CoreLocation/CoreLocation.h>
#import <AddressBookUI/AddressBookUI.h>
#import <Contacts/Contacts.h>
#define YANDEX_MAPS_API_DOMAIN @"http://geocode-maps.yandex.ru/1.x/"
@interface AccountInfoCell()<UITextViewDelegate,LocationPickerDelegate>

@end

@implementation AccountInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.phoneKeyLabel.text = NSLocalizedString(@"Телефон", @"");
    self.genderKeyLabel.text = NSLocalizedString(@"Пол", @"");
    self.visitKeyLabel.text = NSLocalizedString(@"Выезд на дом", @"");
    self.athomeKeyLabel.text = NSLocalizedString(@"У специалиста", @"");
    self.addressLabel.text = NSLocalizedString(@"Адрес не указан", @"");
    [self.male setTitle:NSLocalizedString(@"Мужской", @"") forState:UIControlStateNormal];
    [self.famale setTitle:NSLocalizedString(@"Женский", @"") forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setMaster:(MasterModel *)master{
    if (self.master!=master){
        _master = master;
        self.atHome.on = master.atHome;
        self.visit.on = master.visit;
        self.phoneLabel.text = master.user.phone;
        self.addressLabel.text = master.address;
        if ([self.master.user.gender isEqualToString:@"Муж"]){
            self.male.selected = YES;
            self.famale.selected = NO;
        }
        else {
            self.male.selected = NO;
            self.famale.selected = YES;
        }
        self.aboutView.text = self.master.user.about;
        
        self.aboutLabel.text = self.master.user.about;
        self.genderLabel.text = ([self.master.user.gender isEqualToString:@"Муж"])? NSLocalizedString(@"Мужской",@""):NSLocalizedString(@"Женский",@"");
        self.visitLabel.text = (master.visit)?NSLocalizedString(@"ДА",@""):NSLocalizedString(@"НЕТ",@"");
        self.athomeLabel.text = (master.atHome)?NSLocalizedString(@"ДА",@""):NSLocalizedString(@"НЕТ",@"");
    }
}

- (void)setUser:(UserModel *)user{
    if (self.user!=user){
        _user = user;
        self.phoneLabel.text = user.phone;
        self.addressLabel.text = user.city;
        if ([self.user.gender isEqualToString:@"Муж"]){
            self.male.selected = YES;
            self.famale.selected = NO;
        }
        else {
            self.male.selected = NO;
            self.famale.selected = YES;
        }
        self.aboutView.text = self.user.about;
        
        self.aboutLabel.text = self.user.about;
        self.genderLabel.text = ([self.user.gender isEqualToString:@"Муж"])? NSLocalizedString(@"Мужской",@""):NSLocalizedString(@"Женский",@"");
    }
}

- (IBAction)changeAtHome:(id)sender{
    [[ApiManager new] updateMaster:self.master.id params:@{@"atHome":[NSNumber numberWithBool:self.atHome.isOn]} completition:^(id response, NSError *error) {
        NSLog(@"%@",response);
    }];
}

- (IBAction)changeVisit:(id)sender{
    [[ApiManager new] updateMaster:self.master.id params:@{@"visit":[NSNumber numberWithBool:self.visit.isOn]} completition:^(id response, NSError *error) {
        NSLog(@"%@",response);
    }];
}

- (IBAction)changeGender:(UIButton*)sender{
    self.male.selected = [sender isEqual:self.male];
    self.famale.selected = [sender isEqual:self.famale];
    
    NSString *gender = (self.male.selected)?@"Муж":@"Жен";
    UserModel *user = (self.user)?self.user:self.master.user;
    [[ApiManager new] updateUser:user.id params:@{@"gender":gender} completition:^(id response, NSError *error) {
        NSLog(@"%@",response);
    }];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        if (textView.text.length>0){
            UserModel *user = (self.user)?self.user:self.master.user;
            [[ApiManager new] updateUser:user.id params:@{@"about":textView.text} completition:^(id response, NSError *error) {
                NSLog(@"%@",response);
            }];
        }
        return NO;
    }
    return YES;
}

- (IBAction)chooseAddress:(id)sender{
    SelectLocationOnMap *vc =  [[SelectLocationOnMap alloc] init];
    vc.delegate = self;
    if (![self.master.lat isKindOfClass:[NSNull class]])
        vc.coordinates = CLLocationCoordinate2DMake(self.master.lat.floatValue, self.master.lon.floatValue);
    [[self.delegate navigationController] pushViewController:vc animated:YES];
}

- (void)picker:(SelectLocationOnMap *)picker didChooseLocation:(NSDictionary *)placemark{
    self.addressLabel.text = placemark[@"address"];
    [[ApiManager new] updateMaster:self.master.id params:placemark completition:^(id response, NSError *error) {
        [[self.delegate tableView] reloadData];
    }];
}


@end
