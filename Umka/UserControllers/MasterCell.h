//
//  MasterCell.h
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface MasterCell : TemplateCell
@property (nonatomic, weak) IBOutlet UIView *cellView;
@property (nonatomic, weak) IBOutlet UILabel *master_spec;
@property (nonatomic, weak) IBOutlet UILabel *service1;
@property (nonatomic, weak) IBOutlet UILabel *service2;
@property (nonatomic, weak) IBOutlet UILabel *price1;
@property (nonatomic, weak) IBOutlet UILabel *price2;


@end
