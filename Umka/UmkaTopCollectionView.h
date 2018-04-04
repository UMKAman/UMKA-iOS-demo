//
//  UmkaTopCollectionView.h
//  Umka
//
//  Created by Igor Zalisky on 12/6/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UmkaTopCollectionView : UICollectionViewController
@property (strong, nonatomic) UIButton *menuBtn;
@property (strong, nonatomic) UIButton *searchBtn;
- (IBAction)menuButton:(UIButton *)sender;
@end
