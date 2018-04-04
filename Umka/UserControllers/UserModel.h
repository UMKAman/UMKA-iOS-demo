//
//  UserModel.h
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *about;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *rating;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) NSString *gender;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *reviews;
@property (nonatomic, assign) BOOL isMaster;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
- (UserModel*)updateUser:(NSDictionary*)dict;
@end
