//
//  Dialog.m
//  Umka
//
//  Created by Ігор on 10.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "Dialog.h"

@implementation Dialog

- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.id = dict[@"id"];
        self.master =([dict[@"master"][@"user"] isKindOfClass:[NSDictionary class]])?[[MasterModel alloc] initWithDictionary:dict[@"master"][@"user"]]:nil;
        self.messages = [self messagesFromArray:dict[@"messages"]];
        self.date = [dict[@"createdAt"] dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        self.manager = dict[@"manager"];
        self.user = [[UserModel alloc] initWithDictionary:dict[@"user"]];
    }
    return self;
}

- (NSArray *)messagesFromArray:(NSArray*)array{
    NSMutableArray *ta = [NSMutableArray new];
    for (NSDictionary *dict in array){
        Message *message = [[Message alloc] initWithDictionary:dict];
        [ta addObject:message];
    }
    return ta;
}

@end
