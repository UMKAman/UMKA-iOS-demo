//
//  Message.h
//  Umka
//
//  Created by Ігор on 10.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Message : NSObject
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSNumber *chat;
@property (nonatomic, strong) NSNumber *ownerUser;
@property (nonatomic, strong) NSNumber *ownerMaster;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSDate *date;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, assign) BOOL isSelf;
- (id)initWithDictionary:(NSDictionary*)dict;
@end
