//
//  MapViewController.m
//  Umka
//
//  Created by Ігор on 11.09.17.
//  Copyright © 2017 Igor Zalisky. All rights reserved.
//

#import "MapViewController.h"
#import <GoogleMaps/GoogleMaps.h>
#import <CoreLocation/CoreLocation.h>
#import "AccountPreviewController.h"

@interface UmkaMarker : GMSMarker
@property (nonatomic, strong) MasterModel *master;
@end

@implementation UmkaMarker
@end

@interface MapViewController ()<GMSMapViewDelegate,CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet GMSMapView *mapView_;
@property (nonatomic,strong) NSMutableArray *masters;
@property (nonatomic,strong) NSMutableArray *markers;
@property (nonatomic, strong) CLLocationManager *locationManager;
@property (nonatomic, strong) CLLocation *currentLocation;
@property (nonatomic, strong) GMSMarker *myLocation;
@end

@implementation MapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    self.title = NSLocalizedString(@"Карта",@"");
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.mapView_.myLocation.coordinate.latitude
                                                            longitude:self.mapView_.myLocation.coordinate.longitude
                                                                 zoom:15];
    [self.mapView_ animateWithCameraUpdate:[GMSCameraUpdate setCamera:camera]];
    self.mapView_.myLocationEnabled = NO;
    self.mapView_.delegate = self;
    [self addMarker:nil isMy:YES];
    [self loadMasters];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadMasters{
    self.masters = [NSMutableArray new];
    self.markers = [NSMutableArray new];
    [[ApiManager new] getAllMastersCompletition:^(id response, NSError *error) {
        for (NSDictionary *dict in response){
            MasterModel *master = [[MasterModel alloc] initWithDictionary:dict];
            [self.masters addObject:master];
            if (![master.lat isKindOfClass:[NSNull class]] &&![master.lon isKindOfClass:[NSNull class]])[self addMarker:master isMy:NO];
        }
        
        [self focusMapToShowAllMarkers];
    }];
}

- (void)focusMapToShowAllMarkers
{
    CLLocationCoordinate2D myLocation = ((GMSMarker *)_markers.firstObject).position;
    GMSCoordinateBounds *bounds = [[GMSCoordinateBounds alloc] initWithCoordinate:myLocation coordinate:myLocation];
    
    for (GMSMarker *marker in _markers)
        bounds = [bounds includingCoordinate:marker.position];
    
    [self.mapView_ animateWithCameraUpdate:[GMSCameraUpdate fitBounds:bounds withPadding:15.0f]];
}

- (void)addMarker:(MasterModel*)master isMy:(BOOL)isMy{
    UmkaMarker *marker = [[UmkaMarker alloc] init];
    marker.position =(isMy)?self.currentLocation.coordinate:CLLocationCoordinate2DMake(master.lat.floatValue, master.lon.floatValue);
    marker.title = master.user.name;
    marker.snippet = nil;
    marker.icon = (isMy)?[UIImage imageNamed:@"ic_user_current_location"]:[UIImage imageNamed:@"ic_specialist_location"];
    marker.map = self.mapView_;
    marker.master = master;
    if (isMy)self.myLocation = marker;
    [self.markers addObject:marker];
}

- (void)mapView:(GMSMapView *)mapView didTapInfoWindowOfMarker:(UmkaMarker *)marker{
    AccountPreviewController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountPreviewController"];
    controller.master = marker.master;
    [self.navigationController pushViewController:controller animated:YES];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:(CLLocationCoordinate2D)coordinate{
    
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    /* UIAlertView *errorAlert = [[UIAlertView alloc]
     initWithTitle:@"Умка" message:@"Не могу определить Ваше метоположение" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [errorAlert show];*/
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    if (self.currentLocation!=newLocation)
    {
        self.currentLocation = newLocation;
        self.myLocation.position = self.currentLocation.coordinate;
        //[self.locationManager stopUpdatingLocation];
        if (self.currentLocation != nil) {
            CLGeocoder *geocoder = [[CLGeocoder alloc] init];
            [geocoder reverseGeocodeLocation:self.currentLocation completionHandler:^(NSArray *placemarks, NSError *error) {
                NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
                if (error == nil && [placemarks count] > 0) {
                    CLPlacemark *placemark = [placemarks lastObject];
                    if (placemark.locality)
                    {
                        NSString *latitude =[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.latitude];
                        NSString *longitude =[NSString stringWithFormat:@"%f",self.currentLocation.coordinate.longitude];
                        NSDictionary *dict = @{@"latitude":latitude,@"longitude":longitude,@"city":placemark.locality};
                        [UmkaUser saveUserLocation:dict];
                    }
                    else
                    {
                    }
                } else {
                    NSLog(@"%@", error.debugDescription);
                }
            } ];
        }
    }
}

@end
