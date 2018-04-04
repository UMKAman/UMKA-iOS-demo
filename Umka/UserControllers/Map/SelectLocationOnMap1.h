//
//  SelectLocationOnMap1.h
//  Umka
//
//  Created by Igor Zalisky on 12/14/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LocationPickerDelegate;

@interface SelectLocationOnMap1 : UIViewController
@property (nonatomic, weak) id<LocationPickerDelegate> delegate;
@end

@protocol LocationPickerDelegate <NSObject>
- (void)picker:(SelectLocationOnMap1*)picker didChooseLocation:(NSString*)city;
@end
