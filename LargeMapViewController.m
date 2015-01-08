//
//  LargeMapViewController.m
//  Saint Portal
//
//  Created by David Foster on 07/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "LargeMapViewController.h"
#import <MapKit/MapKit.h>

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

@interface LargeMapViewController () <MKMapViewDelegate>
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@end

@implementation LargeMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.mapView.delegate = self;
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.002;
    span.longitudeDelta=0.002;
    region.span=span;
    region.center=self.coordinates;
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    // Set your annotation to point at your coordinate
    point.coordinate = self.coordinates;
    
    [self.mapView setRegion:region];
    [self.mapView addAnnotation:point];
    
    [self calculateDirections];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)calculateDirections{
    
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinates addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    // Set the source and destination on the request
    [directionsRequest setSource:source];
    [directionsRequest setDestination:destination];
    
    if(self.event != nil){
        [directionsRequest setArrivalDate:self.event.start_time];
    }
    
    [directionsRequest setTransportType:MKDirectionsTransportTypeWalking];
    [directionsRequest setRequestsAlternateRoutes:NO];
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    
    [directions calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        MKRoute *route = [response.routes firstObject];
        
        MKPolyline *line = route.polyline;
        
        [self.mapView addOverlay:line];
        
        
        
    }];
    
    
}

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay
{
    MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
    renderer.strokeColor = UIColorFromRGB(0x00AEEF);
    renderer.lineWidth = 3.0;
    return  renderer;
}

@end
