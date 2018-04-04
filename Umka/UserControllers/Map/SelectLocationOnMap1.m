//
//  SelectLocationOnMap1.m
//  Umka
//
//  Created by Igor Zalisky on 12/14/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "SelectLocationOnMap1.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UmkaUser.h"
#import "LeftMenuTable.h"
#import "SearchFilterController.h"
#import "Constants.h"
#import "AuthorizationController.h"

@interface SelectLocationOnMap1 ()<GMSMapViewDelegate>
{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSDictionary *selectedLocation;
}
@property (nonatomic, strong) GMSMarker* marker;
@end

@implementation SelectLocationOnMap1

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 70, 44)];
    [btn setTitle:NSLocalizedString(@"Закрыть",@"") forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(returnBack) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *lbb = [[UIBarButtonItem alloc] initWithCustomView:btn];
    self.navigationItem.leftBarButtonItem = lbb;
    
    UIButton *btn1 = [[UIButton alloc] initWithFrame:CGRectMake(0.0, 20.0, 70, 44)];
    [btn1 setTitle:NSLocalizedString(@"Готово",@"") forState:UIControlStateNormal];
    [btn1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn1 addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rbb = [[UIBarButtonItem alloc] initWithCustomView:btn1];
    self.navigationItem.rightBarButtonItem = rbb;


    geocoder = [[CLGeocoder alloc] init];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:[UmkaUser latitude].floatValue
                                                            longitude:[UmkaUser longitude].floatValue
                                                                 zoom:7];
    GMSMapView *mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView.myLocationEnabled = YES;
    self.view = mapView;
    mapView.delegate = self;
    
    self.marker = [[GMSMarker alloc] init];
    self.marker.position = CLLocationCoordinate2DMake([UmkaUser latitude].floatValue, [UmkaUser longitude].floatValue);
    self.marker.title = [UmkaUser city];
    self.marker.snippet = nil;
    self.marker.map = mapView;
    
    self.title = NSLocalizedString(@"Выберите город",@"");
    //self.navigationItem.rightBarButtonItem = nil;
}

- (void)returnBack
{
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate picker:self didChooseLocation:placemark.locality];
    }];
}

- (void)done
{
    [UmkaUser saveUserLocation:selectedLocation];
    [self dismissViewControllerAnimated:YES completion:^{
        [self.delegate picker:self didChooseLocation:placemark.locality];
    }];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate {
    NSLog(@"You tapped at %f,%f", coordinate.latitude, coordinate.longitude);
    self.marker.position = coordinate;
    
    self.marker.title = nil;
    self.marker.snippet = nil;
    CLLocation *location = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    [self locationInfo:location];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)locationInfo:(CLLocation*)location
{
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            if (placemark.locality)
            {
                self.marker.title = placemark.locality;
                self.marker.snippet = placemark.country;
                NSString *latitude =[NSString stringWithFormat:@"%f",location.coordinate.latitude];
                NSString *longitude =[NSString stringWithFormat:@"%f",location.coordinate.longitude];
                selectedLocation = @{@"lat":latitude,@"lon":longitude,@"address":placemark.locality};
                
                self.title =placemark.locality;
            }
            else
            {
            }
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];
}



@end
