//
//  IZTextField.m
//  Midrange2017
//
//  Created by Ігор on 10.07.17.
//  Copyright © 2017 ImpactFactors LLC. All rights reserved.
//

#import "IZTextField.h"

@implementation IZTextField

- (void)setSettings:(TextFieldModel *)settings{
    if (self.settings!=settings){
        _settings = settings;
        if ([self.settings.type isEqualToString:@"select"]){
            self.text = self.settings.values[0][@"value"];
            self.value = self.settings.values[0][@"id"];
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Готово",@"") style:UIBarButtonItemStyleDone target:self action:@selector(donePad)];
            //doneBtn.tintColor = [ApplicationSettings accentColor];
            UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            numberToolbar.barStyle = UIBarStyleBlackTranslucent;
                numberToolbar.items = @[
                                        [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil],
                                        doneBtn];
            [numberToolbar sizeToFit];
            self.inputAccessoryView = numberToolbar;
            
            if (!self.pickerView)self.pickerView = [UIPickerView new];
            [self.pickerView setDataSource: self];
            [self.pickerView setDelegate: self];
            self.pickerView.showsSelectionIndicator = YES;
            self.inputView = self.pickerView;
            //self.pickerView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            //self.inputView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
        }
        else if ([self.settings.type isEqualToString:@"date"])
        {
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:NSLocalizedString(@"Готово",@"") style:UIBarButtonItemStyleDone target:self action:@selector(donePad)];
            //doneBtn.tintColor = [ApplicationSettings accentColor];
            UIToolbar* numberToolbar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
            numberToolbar.barStyle = UIBarStyleBlackTranslucent;
            numberToolbar.items = @[
                                    [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil], doneBtn];
            [numberToolbar sizeToFit];
            self.inputAccessoryView = numberToolbar;
            
            if (!self.datePicker)self.datePicker = [UIDatePicker new];
            [self.datePicker setMaximumDate:[NSDate date]];
            [self.datePicker setDatePickerMode:UIDatePickerModeDate];
            self.inputView = self.datePicker;
            //self.datePicker.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            //self.inputView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.5];
            [self.datePicker addTarget:self action:@selector(changeDate) forControlEvents:UIControlEventValueChanged];
        }
    }
}

- (void)changeDate
{
    NSDateFormatter *formatter;
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    self.text = [formatter stringFromDate:self.datePicker.date];
}

- (void)cancelPad
{
    
}

- (void)donePad
{
    [self resignFirstResponder];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.settings.values.count;
}

- (NSString*)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSDictionary *value = self.settings.values[row];
    return value[@"value"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *value = self.settings.values[row];
    self.text = value[@"value"];
    self.value = value[@"id"];
}



@end
