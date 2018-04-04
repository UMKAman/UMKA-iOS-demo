//
//  RegistrationField.h
//  Midrange2017
//
//  Created by Ігор on 10.07.17.
//  Copyright © 2017 ImpactFactors LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TextFieldModel : NSObject
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *label;
@property (nonatomic, assign) BOOL required;
@property (nonatomic, strong) NSString *keyboard;
@property (nonatomic, strong) NSArray *values;
- (id)initWithDictionary:(NSDictionary*)dict;
@end
