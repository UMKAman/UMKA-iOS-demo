//
//  RegistrationField.m
//  Midrange2017
//
//  Created by Ігор on 10.07.17.
//  Copyright © 2017 ImpactFactors LLC. All rights reserved.
//

#import "TextFieldModel.h"

@implementation TextFieldModel
- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.name = dict[@"name"];
        self.type = dict[@"type"];
        self.label = dict[@"label"];
        self.required = [dict[@"required"] boolValue];
        self.keyboard = dict[@"keyboard"];
        self.values = dict[@"values"];
    }
    return self;
}
@end
