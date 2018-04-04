//
//  SelectLocationOnMap.m
//  Umka
//
//  Created by Igor Zalisky on 12/14/16.
//  Copyright © 2016 Igor Zalisky. All rights reserved.
//

#import "SelectLocationOnMap.h"
#import <GoogleMaps/GoogleMaps.h>
#import "UmkaUser.h"
#import "LeftMenuTable.h"
#import "SearchFilterController.h"
#import "Constants.h"
#import "AuthorizationController.h"
#import "AccountInfoCell.h"

#define YANDEX_MAPS_API_DOMAIN @"http://geocode-maps.yandex.ru/1.x/"

@interface SelectLocationOnMap ()<GMSMapViewDelegate>
{
    CLGeocoder *geocoder;
    CLPlacemark *placemark;
    NSDictionary *selectedLocation;
}
@property (nonatomic, strong) GMSMarker* marker;
@property (nonatomic, strong) GMSMapView *mapView;
@end

@implementation SelectLocationOnMap

- (void)viewDidLoad {
    [super viewDidLoad];
    if (![self.delegate isKindOfClass:[LeftMenuTable class]])
    {
        UIBarButtonItem *barButton = self.navigationController.navigationItem.leftBarButtonItem;
        barButton.title = @"";
        [barButton setTarget:self];
        [barButton setAction:@selector(returnBack)];
        self.navigationController.navigationItem.leftBarButtonItem = barButton;
    }
    geocoder = [[CLGeocoder alloc] init];
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:0.0
                                                            longitude:0.0
                                                                 zoom:0];
    self.mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    self.mapView.myLocationEnabled = YES;
    self.view = self.mapView;
    self.mapView.delegate = self;

    if (self.address)[self getCoordinates];
    else if (self.coordinates.longitude!=0 && self.coordinates.latitude!=0)
        [self showMarker:self.coordinates.latitude lon:self.coordinates.longitude];
    else [self showMarker:[UmkaUser latitude].floatValue lon:[UmkaUser longitude].floatValue];
    
    
    self.title = NSLocalizedString(@"Выберите город",@"");
     self.navigationItem.rightBarButtonItem = nil;
}

- (void)showMarker:(CGFloat)latitude lon:(CGFloat)longitude{
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:latitude
                                                            longitude:longitude
                                                                 zoom:10];
    [self.mapView animateWithCameraUpdate:[GMSCameraUpdate setCamera:camera]];
    self.marker = [[GMSMarker alloc] init];
    self.marker.position = CLLocationCoordinate2DMake(latitude, longitude);
    self.marker.title = nil;
    self.marker.snippet = nil;
    self.marker.map = self.mapView;
}

- (void)getCoordinates{
    [geocoder geocodeAddressString:self.address
                 completionHandler:^(NSArray* placemarks, NSError* error){
                     if (placemarks && placemarks.count > 0) {
                         CLPlacemark *topResult = [placemarks objectAtIndex:0];
                         [self showMarker:topResult.location.coordinate.latitude lon:topResult.location.coordinate.longitude];
                     }
                 }
     ];
}

- (void)returnBack
{
    [self.navigationController popViewControllerAnimated:YES];
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
    [self getAddressFromLatLon:location];
    /*[geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        NSLog(@"Found placemarks: %@, error: %@", placemarks, error);
        if (error == nil && [placemarks count] > 0) {
            placemark = [placemarks lastObject];
            if (placemark.locality)
            {
                self.marker.title = placemark.locality;
                self.marker.snippet = placemark.country;
                NSString *latitude =[NSString stringWithFormat:@"%f",location.coordinate.latitude];
                NSString *longitude =[NSString stringWithFormat:@"%f",location.coordinate.longitude];
                selectedLocation = @{@"latitude":latitude,@"longitude":longitude,@"city":placemark.locality};
                
                [self showAlert:[NSString stringWithFormat:@"Вы выбрали город - %@\n",
                                 placemark.locality]];
            }
            else
            {
                [self showErrorAlert:@"Не удалось определить город, сделайте свой выбор еще раз"];
            }
        } else {
            NSLog(@"%@", error.debugDescription);
        }
    } ];*/
}

- (void) getAddressFromLatLon:(CLLocation *)bestLocation
{
    [SVProgressHUD show];
    CLLocationCoordinate2D coordinate = bestLocation.coordinate;
    NSString *coordinatesString = [NSString stringWithFormat:@"%lf,%lf", coordinate.longitude, coordinate.latitude];
    
    // Creating HTTP request. Here kind=locality means that we will be searching for a city.
    NSString *urlString = [NSString stringWithFormat:@"%@?geocode=%@&results=1&lang=%@&format=json", YANDEX_MAPS_API_DOMAIN, coordinatesString,NSLocalizedString(@"ru-RU", @"")];
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:url];
    
    // Sending synchronous request in background queue using dispatch queues
    dispatch_queue_t backgroundQueue = dispatch_queue_create("bgQueue", nil);
    dispatch_async(backgroundQueue, ^{
        __autoreleasing NSHTTPURLResponse *urlResponse = nil;
        __autoreleasing NSError *error = nil;
        NSData *resultData = [NSURLConnection sendSynchronousRequest:urlRequest returningResponse:&urlResponse error:&error];
        
        // Parsing a result
        if (! error) {
            NSLog(@"Status Code: %ld %@", (long)[urlResponse statusCode], [NSHTTPURLResponse localizedStringForStatusCode:[urlResponse statusCode]]);
            
            NSDictionary *jsonObject = [NSJSONSerialization JSONObjectWithData:resultData
                                                                       options:(NSJSONReadingOptions)kNilOptions
                                                                         error:&error];
            
            // If count is zero, then region is not found
            long count = [jsonObject[@"response"][@"GeoObjectCollection"][@"metaDataProperty"][@"GeocoderResponseMetaData"][@"found"] integerValue];
            if (count == 0) {
                /*dispatch_async(dispatch_get_main_queue(), ^{
                 [self showRegionNotFoundError];
                 });*/
                return;
            }
            
            // Searching in a JSON
            NSString *formattedAddress = [jsonObject[@"response"][@"GeoObjectCollection"][@"featureMember"] firstObject][@"GeoObject"][@"metaDataProperty"][@"GeocoderMetaData"][@"text"];
            NSString *city = [jsonObject[@"response"][@"GeoObjectCollection"][@"featureMember"] firstObject][@"GeoObject"][@"description"];
            
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD dismiss];
                NSString *latitude =[NSString stringWithFormat:@"%f",bestLocation.coordinate.latitude];
                NSString *longitude =[NSString stringWithFormat:@"%f",bestLocation.coordinate.longitude];
                NSDictionary *params = @{@"lat":latitude,@"lon":longitude,@"address":formattedAddress,@"city":city};
                [UmkaUser saveUserLocation:params];
                [self showAlert:[NSString stringWithFormat:@"%@ - %@\n",NSLocalizedString(@"Вы выбрали",@""),
                                 formattedAddress] params:params];
            });
            
        }
        else {
            
            [self showErrorAlert:NSLocalizedString(@"Не удалось определить город, сделайте свой выбор еще раз",@"")];
        }
        
    });
}


- (void)showAlert:(NSString*)message params:(NSDictionary*)params
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Умка",@"")
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"Закрыть",@"")
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    
    UIAlertAction* choose = [UIAlertAction actionWithTitle:NSLocalizedString(@"Сохранить",@"")
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {
                             [UmkaUser saveUserLocation:params];
                              [alert dismissViewControllerAnimated:YES completion:nil];
                             if ([self.delegate isKindOfClass:[LeftMenuTable class]])
                             {
                                 [self.delegate picker:self didChooseLocation:params];
                                 [self menuButton:nil];
                             }
                             else {
                                 [[NSNotificationCenter defaultCenter] postNotificationName:K_RELOAD_MAIN_MENU object:nil];
                                 [self.delegate picker:self didChooseLocation:params];
                                 [self.navigationController popViewControllerAnimated:YES];
                             }
                             
                         }];
    [alert addAction:choose];
    
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)showErrorAlert:(NSString*)message
{
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Умка",@"")
                                                                    message:message
                                                             preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK",@"")
                                                 style:UIAlertActionStyleDefault
                                               handler:^(UIAlertAction * action)
                         {[alert dismissViewControllerAnimated:YES completion:nil];}];
    [alert addAction:ok];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
