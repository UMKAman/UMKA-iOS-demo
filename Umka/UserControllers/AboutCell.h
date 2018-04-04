//
//  AboutCell.h
//  Umka
//
//  Created by Igor Zalisky on 12/19/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MasterModel;
@interface AboutCell : UITableViewCell
@property (nonatomic, strong) MasterModel *master;
@property (nonatomic, weak) IBOutlet UIView *cellView;
@property (nonatomic, weak) id delegate;
- (void)reloadCell:(CGFloat)height;
@end
