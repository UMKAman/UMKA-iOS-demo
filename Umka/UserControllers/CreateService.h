//
//  AddPriceController.h
//  Umka
//
//  Created by Igor Zalisky on 12/28/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreateServiceDelegate;

@interface CreateService : UITableViewController
- (void)selectCategory:(CategoryModel*)model;
@property (nonatomic,strong)MasterModel *master;
@property (nonatomic,weak)id <CreateServiceDelegate>delegate;
@end

@protocol CreateServiceDelegate <NSObject>
- (void)serviceDidCreated:(Service*)service;
@end
