//
//  AccountCategoryCell.m
//  Umka
//
//  Created by Ігор on 24.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "AccountCategoryCell.h"
#import "AccountCategories.h"

@implementation AccountCategoryCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.layer.cornerRadius = 20.0;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setCategory:(CategoryModel *)category{
    if (self.category!=category){
        _category = category;
        self.parent.text = @"";
        self.parentHeight.constant = 0.0;
        self.name.text = category.name;
        if (self.category.parent){
            self.parentHeight.constant = 21.0;
            self.parent.text = category.parent.name;
            self.icon.backgroundColor = category.parent.color;
            [self.icon sd_setImageWithURL:[NSURL URLWithString:self.category.parent.pic]];
        }
        else if (self.category.parentID.integerValue!=0) [self getParrentInfo:category];
        else{
            self.icon.backgroundColor = category.color;
            [self.icon sd_setImageWithURL:[NSURL URLWithString:category.pic]];
        }
    }
}

- (void)getParrentInfo:(CategoryModel*)cat{
    CategoryModel *category = [cat searchParent:self.categories];
    if (category.parentID){
        [self getParrentInfo:category];
    }
    else if (category.parent){
        self.icon.backgroundColor = category.parent.color;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:category.parent.pic]];
        self.parent.text = (self.parent.text.length>0)?[NSString stringWithFormat:@"%@ - %@",self.parent.text,category.parent.name]:category.parent.name;
    }
    else {
        self.icon.backgroundColor = category.color;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:category.pic]];
    }
    self.parent.text = (self.parent.text.length>0)?[NSString stringWithFormat:@"%@ - %@",self.parent.text,category.name]:category.name;
    self.parentHeight.constant = 21.0;
}

- (IBAction)removeCategoryAction{
    [self.delegate removeCategory:self.category];
}

@end
