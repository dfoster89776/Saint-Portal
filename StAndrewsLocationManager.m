//
//  StAndrewsLocationManager.m
//  Saint Portal
//
//  Created by David Foster on 18/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "StAndrewsLocationManager.h"
#import <UIKit/UIKit.h>

@interface StAndrewsLocationManager () <CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager *locationManager;
@end

@implementation StAndrewsLocationManager

-(void)setupLocationManager{
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager requestAlwaysAuthorization];
    
}

- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
    
    NSLog(@"Region entered");
    
    /*
     A user can transition in or out of a region while the application is not running. When this happens CoreLocation will launch the application momentarily, call this delegate method and we will let the user know via a local notification.
     */
    
    
     
     //If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
     //If it's not, iOS will display the notification to the user.
     
    
}

-(void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region{
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"iBeacon"
                                                    message:@"You have entered a region."
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    if (![CLLocationManager locationServicesEnabled]) {
        NSLog(@"Couldn't turn on ranging: Location services are not enabled.");
    }
    
    else if (([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedAlways) || ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusAuthorizedWhenInUse)) {
        NSLog(@"Couldn't turn on monitoring: Location services not authorised.");
    }
    
    else if (([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedAlways) || ([CLLocationManager authorizationStatus] == kCLAuthorizationStatusAuthorizedWhenInUse)) {
        
        NSUUID *uuid = [[NSUUID alloc] initWithUUIDString:@"2F234454-CF6D-4A0F-ADF2-F4911BA9FFA6"];
        
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:uuid identifier:@"Saint Andrews University"];
        region.notifyOnEntry = YES;
        region.notifyEntryStateOnDisplay = YES;
        [self.locationManager startMonitoringForRegion:region];
        
    }
}

@end
