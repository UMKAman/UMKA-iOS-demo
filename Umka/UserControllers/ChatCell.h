//
//  ChatCell.h
//  Umka
//
//  Created by Igor Zalisky on 12/11/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MessageModel;
@interface ChatCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UIImageView *avatar;
@property (nonatomic, weak) IBOutlet UIImageView *photo;
@property (nonatomic, weak) IBOutlet UILabel *user;
@property (nonatomic, weak) IBOutlet UILabel *message;
@property (nonatomic, weak) IBOutlet UILabel *status;
@property (nonatomic, weak) IBOutlet UIView *messageBG;
@property (nonatomic, strong) Message *model;
@property (nonatomic, strong) Dialog *dialog;
@property (nonatomic, weak) id delegate;
@end
