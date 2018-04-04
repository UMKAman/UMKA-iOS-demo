//
//  UserChatController.h
//  Umka
//
//  Created by Igor Zalisky on 12/11/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MasterModel.h"
@interface UserChatController : UITableViewController
@property (nonatomic, strong) Dialog *dialog;
- (void)setupPhotoBrouser:(NSString*)url;
@end
