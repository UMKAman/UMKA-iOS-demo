//
//  UserOrderModel.h
//  Umka
//
//  Created by Igor Zalisky on 11/25/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "UserModel.h"

@interface UserOrderModel : NSObject
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) MasterModel *master;
@property (nonatomic, strong) UserModel *user;
@property (nonatomic, assign) BOOL masterApprove;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
@end
