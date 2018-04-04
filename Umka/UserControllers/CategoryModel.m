//
//  CategoryModel.m
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "CategoryModel.h"

@implementation CategoryModel

- (instancetype)initWithDictionary:(NSDictionary*)dict 
{
    self = [super init];
    if (self) {
        self.id = dict[@"id"];
        NSString *nameKey = NSLocalizedString(@"name", @"");
        self.name = dict[nameKey];
        if ([self.name isKindOfClass:[NSNull class]]) self.name = dict[@"name"];
        if ([dict[@"pic"] length]>0)self.pic = [NSString stringWithFormat:@"%@%@",K_API_DOMAIN_URL,dict[@"pic"]];
        self.color = [self generateColorFromHex:dict[@"color"]];
        if ([dict[@"parent"] isKindOfClass:[NSDictionary class]])
            self.parent = [[CategoryModel alloc] initWithDictionary:dict[@"parent"]];
        if ([dict[@"parent"] isKindOfClass:[NSNumber class]])
            self.parentID = dict[@"parent"];
        self.child = dict[@"child"];
    }
    return self;
}

- (CategoryModel*)searchParent:(NSArray*)categories{
        CategoryModel *category = nil;
        for (CategoryModel *model in categories){
            if (model.id.integerValue==self.parentID.integerValue){
                category = model;
                break;
            }
        }
    return category;
}


- (UIColor*)generateColorFromHex:(NSString*)hexString
{
    if (hexString.length==0||!hexString) return [UIColor clearColor];
    unsigned rgbValue = 0;
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:1]; // bypass '#' character
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
}

@end
