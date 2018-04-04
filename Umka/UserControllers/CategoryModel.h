//
//  CategoryModel.h
//  Umka
//
//  Created by Igor Zalisky on 11/24/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface CategoryModel : NSObject
@property (nonatomic, strong) NSNumber *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *pic;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) NSArray *child;
@property (nonatomic, strong) CategoryModel *parent;
@property (nonatomic, strong) NSNumber *parentID;
- (instancetype)initWithDictionary:(NSDictionary*)dict;
- (CategoryModel*)searchParent:(NSArray*)categories;
@end
