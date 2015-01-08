//
//  StaffDetailsViewController.m
//  Saint Portal
//
//  Created by David Foster on 08/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "StaffDetailsViewController.h"
#import <MessageUI/MessageUI.h>
#import "LargeMapViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

@interface StaffDetailsViewController () <MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *emailButton;
@property (strong, nonatomic) IBOutlet UIButton *phoneNumberButton;
@property (strong, nonatomic) IBOutlet UIView *contactDetailsView;
@property (strong, nonatomic) IBOutlet UILabel *roomLabel;
@property (strong, nonatomic) IBOutlet UILabel *buildingLabel;
@property (nonatomic) CLLocationCoordinate2D coordinates;
@property (strong, nonatomic) IBOutlet MKMapView *smallMapView;
@end

@implementation StaffDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Details";
    [self.emailButton setTitle:self.staff.email forState:UIControlStateNormal];
    [self.phoneNumberButton setTitle:self.staff.phone_number forState:UIControlStateNormal];
    
    if(![MFMailComposeViewController canSendMail]){
        
        [self.emailButton setEnabled:false];
        
    }
    
    UIView *bottomBorder = [UIView new];
    bottomBorder.backgroundColor = UIColorFromRGB(0x00AEEF);
    bottomBorder.frame = CGRectMake(0, self.contactDetailsView.frame.size.height, self.contactDetailsView.frame.size.width, 1);
    [self.contactDetailsView addSubview:bottomBorder];
    
    double latitude;
    double longitude;
    
    latitude = 56.340274;
    longitude = -2.808708;
    
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


}

-(void)handleGesture:(UIGestureRecognizer *)gestureRecogniser{
    
    [self performSegueWithIdentifier:@"showLargeMap" sender:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)callPhoneNumber:(id)sender {

    NSString *theCall = [NSString stringWithFormat:@"tel://%@", self.staff.phone_number];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:theCall]];

}

- (IBAction)sendEmail:(id)sender {
    
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    NSArray* toRecipients = [NSArray arrayWithObject:self.staff.email];
    [picker setToRecipients:toRecipients];
    
    [self presentViewController:picker animated:YES completion:nil];
    
}

-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showLargeMap"]){
        
        LargeMapViewController *lmvc = segue.destinationViewController;
        lmvc.coordinates = self.coordinates;
        
    }
}

@end
