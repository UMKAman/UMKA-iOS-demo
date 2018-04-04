//
//  SelectLocationOnMap.h
//  Umka
//
//  Created by Igor Zalisky on 12/14/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UmkaTopViewController.h"
#import <CoreLocation/CoreLocation.h>
@protocol LocationPickerDelegate;

@interface SelectLocationOnMap : UmkaTopViewController
@property (nonatomic, weak) id<LocationPickerDelegate> delegate;
@property (nonatomic, strong) NSString *address;
@property (nonatomic, assign) CLLocationCoordinate2D coordinates;
@end


@protocol LocationPickerDelegate <NSObject>
- (void)picker:(SelectLocationOnMap*)picker didChooseLocation:(NSDictionary*)placemark;
@end

