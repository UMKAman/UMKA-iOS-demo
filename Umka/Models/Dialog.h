//
//  Dialog.h
//  Umka
//
//  Created by Ігор on 10.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterModel.h"
#import "Message.h"

@interface Dialog : NSObject
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) MasterModel *master;
@property (nonatomic, strong) NSArray <Message*>* messages;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *manager;
@property (nonatomic, strong) UserModel *user;
- (id)initWithDictionary:(NSDictionary*)dict;
@end
