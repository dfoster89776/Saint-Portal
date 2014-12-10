//
//  DashViewController.m
//  Saint Portal
//
//  Created by David Foster on 29/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "DashViewController.h"
#import "Coursework.h"
#import "CourseworkDetailsViewController.h"
#import "DashboardUpcomingCourseworkTableViewController.h"

@interface DashViewController ()
@property (strong, nonatomic) IBOutlet UIView *headingOuterView;
@property (strong, nonatomic) UIView *headingInnerView;
@property (nonatomic) int x;
@end

@implementation DashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
}

-(void)viewDidLayoutSubviews{
    
    NSLog(@"Container width: %f", self.headingOuterView.frame.size.width);
    
    int width = self.headingOuterView.frame.size.width;
    
    self.x = (width / 2) - 100;
    int height = self.headingOuterView.frame.size.height;
    
    UIView* headingInnerContainer = [[UIView alloc] initWithFrame:CGRectMake(self.x, 0, 400, height)];
    
    [headingInnerContainer setBackgroundColor:[UIColor greenColor]];
    [self.headingOuterView addSubview:headingInnerContainer];
    
    UILabel *eventsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, height)];
    
    [eventsLabel setText:@"Events"];
    [eventsLabel setTextColor:[UIColor blackColor]];
    [eventsLabel setBackgroundColor:[UIColor clearColor]];
    [eventsLabel setFont:[UIFont fontWithName: @"Helvatica Neue" size: 20.0f]];
    eventsLabel.textAlignment = NSTextAlignmentCenter;
    
    UILabel *courseworkLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, 200, height)];
    
    [courseworkLabel setText:@"Coursework"];
    [courseworkLabel setTextColor:[UIColor blackColor]];
    [courseworkLabel setBackgroundColor:[UIColor clearColor]];
    [courseworkLabel setFont:[UIFont fontWithName: @"Helvatica Neue" size: 20.0f]];
    courseworkLabel.textAlignment = NSTextAlignmentCenter;
    
    [headingInnerContainer addSubview:eventsLabel];
    [headingInnerContainer addSubview:courseworkLabel];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)titleForIndex:(NSUInteger)index{
    
    int height = self.headingOuterView.frame.size.height;
    
    if(index == 0){

        NSLog(@"HERE0");
        
        
        
    }else if (index == 1){
        
        NSLog(@"HERE1");
        
        
    }
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if([segue.identifier isEqualToString:@"showCourseworkDetails"]){
        
        Coursework *openCoursework = [(DashboardUpcomingCourseworkTableViewController *)sender getSelectedCourseworkItem];
        
        CourseworkDetailsViewController *destination = segue.destinationViewController;
        
        destination.coursework = openCoursework;
        destination.title = @"Coursework";
        
    }
    
}


@end
