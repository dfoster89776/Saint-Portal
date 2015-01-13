//
//  EventDetailsViewController.m
//  Saint Portal
//
//  Created by David Foster on 06/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "EventDetailsViewController.h"
#import <MapKit/MapKit.h>
#import "Rooms.h"
#import "Modules.h"
#import "Buildings.h"
#import "LargeMapViewController.h"
#import "AppDelegate.h"
#import "Event.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]


@interface EventDetailsViewController ()
@property (strong, nonatomic) IBOutlet UILabel *moduleLabel;
@property (strong, nonatomic) IBOutlet UILabel *eventTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *startTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *endTimeLabel;
@property (strong, nonatomic) IBOutlet UIView *timeContainerView;
@property (strong, nonatomic) IBOutlet UILabel *eventLocation;
@property (strong, nonatomic) IBOutlet MKMapView *smallMapView;
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) IBOutlet UIView *travelTimeView;
@property (strong, nonatomic) IBOutlet UILabel *eventNowLabel;
@property (strong, nonatomic) IBOutlet UILabel *walkingTimeHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *leaveByHeaderLabel;
@property (strong, nonatomic) IBOutlet UILabel *walkingTimeLabel;
@property (strong, nonatomic) IBOutlet UILabel *leaveByLabel;
@property (strong, nonatomic) IBOutlet UIView *calculatingTravelTimeView;
@end

@implementation EventDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIView *leftBorder = [UIView new];
    leftBorder.backgroundColor = [UIColor whiteColor];
    leftBorder.frame = CGRectMake(0, 0, 1, self.timeContainerView.frame.size.height);
    [self.timeContainerView addSubview:leftBorder];
    
    UIView *bottomBorder = [UIView new];
    bottomBorder.backgroundColor = UIColorFromRGB(0x00AEEF);
    bottomBorder.frame = CGRectMake(0, self.travelTimeView.frame.size.height, self.travelTimeView.frame.size.width, 1);
    [self.travelTimeView addSubview:bottomBorder];
    
    self.moduleLabel.text = self.event.event_module.module_code;
    self.eventTypeLabel.text = [self.event.event_type stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                         withString:[[self.event.event_type substringToIndex:1] capitalizedString]];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    
    if([self.event.start_time compare:[NSDate date]] == NSOrderedAscending){
        
        [self.startTimeLabel setHidden:true];
        [self.endTimeLabel setHidden:true];
        [self.eventNowLabel setHidden:false];
    }else{
        self.startTimeLabel.text = [df stringFromDate:self.event.start_time];
        self.endTimeLabel.text = [df stringFromDate:self.event.end_time];
        [self.startTimeLabel setHidden:false];
        [self.endTimeLabel setHidden:false];
        [self.eventNowLabel setHidden:true];
    }
    
    self.eventLocation.text = [NSString stringWithFormat:@"%@, %@", self.event.event_location.room_name, self.event.event_location.rooms_building.building_name];
    
    double latitude = [self.event.event_location.rooms_building.lattitude doubleValue];
    double longitude = [self.event.event_location.rooms_building.longitude doubleValue];
    
    NSLog(@"Coordinates: %f, %f", latitude, longitude);
    
    self.coordinates = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta=0.002;
    span.longitudeDelta=0.002;
    region.span=span;
    region.center=self.coordinates;
    
    MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
    // Set your annotation to point at your coordinate
    point.coordinate = self.coordinates;
    
    [self.smallMapView setRegion:region];
    [self.smallMapView addAnnotation:point];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleGesture:)];
    tgr.numberOfTapsRequired = 1;
    [self.smallMapView addGestureRecognizer:tgr];
    
    if([self eventIsNextEvent]){
        
        [self calculateDirections];
        
    }else{
        [self.travelTimeView removeFromSuperview];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)handleGesture:(UIGestureRecognizer *)gestureRecogniser{
    
    [self performSegueWithIdentifier:@"showLargeMap" sender:self];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showLargeMap"]){
        
        LargeMapViewController *lmvc = segue.destinationViewController;
        lmvc.coordinates = self.coordinates;
        lmvc.event = self.event;
        
    }
}

-(void)calculateDirections{
    
    MKDirectionsRequest *directionsRequest = [MKDirectionsRequest new];
    
    MKMapItem *source = [MKMapItem mapItemForCurrentLocation];
    
    MKPlacemark *destinationPlacemark = [[MKPlacemark alloc] initWithCoordinate:self.coordinates addressDictionary:nil];
    MKMapItem *destination = [[MKMapItem alloc] initWithPlacemark:destinationPlacemark];
    // Set the source and destination on the request
    [directionsRequest setSource:source];
    [directionsRequest setDestination:destination];
    [directionsRequest setArrivalDate:self.event.start_time];
    [directionsRequest setTransportType:MKDirectionsTransportTypeWalking];
    [directionsRequest setRequestsAlternateRoutes:NO];
    MKDirections *directions = [[MKDirections alloc] initWithRequest:directionsRequest];
    
    [directions calculateETAWithCompletionHandler:^(MKETAResponse *response, NSError *error) {
        
        NSTimeInterval travelTime = response.expectedTravelTime;
        
        NSDate *departureTime = [NSDate dateWithTimeInterval:-travelTime sinceDate:self.event.start_time];
        
        
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"HH:mm"];
        
        [self.calculatingTravelTimeView setHidden:true];
        [self.walkingTimeHeaderLabel setHidden:false];
        [self.walkingTimeLabel setHidden:false];
        [self.leaveByHeaderLabel setHidden:false];
        [self.leaveByLabel setHidden:false];
        [self.leaveByLabel setText:[df stringFromDate:departureTime]];
        [self.walkingTimeLabel setText:[self formattedStringForDuration:travelTime]];
        
    }];
    
    
}

-(Boolean)eventIsNextEvent{
    
    if(!self.context){
        
        self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    }
    
    NSDate *now = [NSDate date];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(start_time > %@)", now];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start_time" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    
    NSArray *items = [self.context executeFetchRequest:request error:&error];
    
    Event *nextEvent = [items firstObject];
    
    if((nextEvent == self.event) && ([[NSCalendar currentCalendar] isDateInToday:self.event.start_time])){
        return YES;
    }else{
        return NO;
    }
}

- (NSString*)formattedStringForDuration:(NSTimeInterval)duration
{
    NSInteger minutes = floor(duration/60);
    return [NSString stringWithFormat:@"%ld Minutes", (long)minutes];
}

@end
