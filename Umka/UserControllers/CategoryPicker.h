//
//  CategoryPicker.h
//  Umka
//
//  Created by Igor Zalisky on 12/23/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CategoryPickerDelegate;

@interface CategoryPicker : UITableViewController
@property (nonatomic, weak) id <CategoryPickerDelegate>delegate;
@property (nonatomic, strong) NSMutableArray *categories;
@property (nonatomic, strong) NSMutableArray *allCategories;
@property (nonatomic,strong)MasterModel *master;
@end


@protocol CategoryPickerDelegate <NSObject>

- (void)categoryPicker:(CategoryPicker*)cate
             didChooseCategory:(CategoryModel*)category;

@end
