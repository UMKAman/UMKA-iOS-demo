//
//  Message.m
//  Umka
//
//  Created by Ігор on 10.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "Message.h"

@implementation Message
- (id)initWithDictionary:(NSDictionary*)dict
{
    self = [super init];
    if (self) {
        self.id = dict[@"id"];
        self.chat = dict[@"chat"];
        self.ownerUser = dict[@"ownerUser"];
        self.ownerMaster = dict[@"ownerMaster"];
        
        //self.text = [dict[@"text"] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        self.date = [dict[@"createdAt"] dateWithFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        self.pic = (![dict[@"pic"] isKindOfClass:[NSNull class]])?[NSString stringWithFormat:@"https://umka.city%@",dict[@"pic"]]:@"";
        self.isSelf = [self detectIsSelf];
        
        NSString *text = ([dict[@"text"] isKindOfClass:[NSNull class]])?@"":dict[@"text"];
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        self.text = [[NSString alloc] initWithData:data encoding:NSNonLossyASCIIStringEncoding];
        if (self.text==nil)self.text = text;
        self.text = [self.text stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        self.text = [self.text stringByReplacingOccurrencesOfString:@"+" withString:@" "];
    }
    return self;
}

- (BOOL)detectIsSelf{
    NSString *appMode = [UmkaUser appMode];
    if ([appMode isEqualToString:@"user"] && ![self.ownerUser isKindOfClass:[NSNull class]])return YES;
    else if ([appMode isEqualToString:@"master"] && ![self.ownerMaster isKindOfClass:[NSNull class]])return YES;
    else return NO;
}


@end
