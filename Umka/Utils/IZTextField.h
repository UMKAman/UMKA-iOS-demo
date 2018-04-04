//
//  IZTextField.h
//  Midrange2017
//
//  Created by Ігор on 10.07.17.
//  Copyright © 2017 ImpactFactors LLC. All rights reserved.
//

#import "JJMaterialTextfield.h"
#import "TextFieldModel.h"

@interface IZTextField : JJMaterialTextfield<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) TextFieldModel *settings;
@property (nonatomic, strong) NSArray *fields;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSNumber *value;
@end
