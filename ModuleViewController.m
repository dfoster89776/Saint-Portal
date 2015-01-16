//
//  ModuleViewController.m
//  Saint Portal
//
//  Created by David Foster on 09/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "ModuleViewController.h"
#import "AppDelegate.h"
#import "Coursework.h"
#import "ModuleCourseworkTableViewController.h"
#import "CourseworkDetailsViewController.h"
#import "ModuleTopicsTableViewController.h"
#import "TopicsPostsTableViewController.h"
#import "AllPostsTableViewController.h"
#import "ModuleStaffTableViewController.h"
#import "EventDetailsViewController.h"
#import "ModuleEventsTableViewController.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

@interface ModuleViewController ()
@property (strong, nonatomic) IBOutlet UIScrollView *headerScrollView;
@property (nonatomic) int width;
@end

@implementation ModuleViewController
@synthesize moduleName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

-(void)viewDidLayoutSubviews{
    
    NSArray *headerArray = [NSArray arrayWithObjects:@"Overview",@"Topics & Posts", @"Coursework", @"Events", nil];
    
    self.width = self.headerScrollView.frame.size.width;
    
    int contentWidth = (self.width) * (([headerArray count]/2) + 0.5);
    int height = self.headerScrollView.frame.size.height;
    
    self.headerScrollView.contentSize = CGSizeMake(contentWidth, height);
    
    UIView *innerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, contentWidth, height)];
    
    [self.headerScrollView addSubview:innerView];
    
    
    for(NSString *header in headerArray){
        
        int index = (int)[headerArray indexOfObject:header];
        
        int eventXCoordinate = (self.width/4) + ((self.width/2)*index);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(eventXCoordinate, 0, self.width/2, height)];
        
        [label setText:header];
        [label setTextColor:UIColorFromRGB(0x00539B)];
        
        [label setFont:[UIFont fontWithName: @"HelveticaNeue-Light" size: 20.0f]];
        label.textAlignment = NSTextAlignmentCenter;
        [innerView addSubview:label];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)titleForIndex:(NSUInteger)index{
    
    int xoffset = 0 + (int)(index * self.width/2);
    
    [self.headerScrollView setContentOffset:CGPointMake(xoffset, 0) animated:YES];
    
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"ModulePageViewControllerEmbed"]){
        
        [segue.destinationViewController setModule:self.module];
        
    }else if([segue.identifier isEqualToString:@"showCourseworkDetails"]){
        
        Coursework *openCoursework = [(ModuleCourseworkTableViewController *)sender getSelectedCourseworkItem];
     
        CourseworkDetailsViewController *destination = segue.destinationViewController;
        
        destination.coursework = openCoursework;
        destination.title = @"Coursework";
    
    }else if ([segue.identifier isEqualToString:@"showTopicsPosts"]){
        
        Topics *selectedTopic = [(ModuleTopicsTableViewController *)sender getSelectedTopic];
        
        TopicsPostsTableViewController *destination = segue.destinationViewController;
        
        destination.topic = selectedTopic;
        destination.title = selectedTopic.topic_name;
        
    }else if ([segue.identifier isEqualToString:@"showAllPosts"]){
        
        AllPostsTableViewController *destination = segue.destinationViewController;
        
        destination.module = self.module;
        
    }else if ([segue.identifier isEqualToString:@"showModuleStaff"]){
        
        ModuleStaffTableViewController *destination = segue.destinationViewController;
        destination.module = self.module;
        destination.title = @"Staff";
    }else if ([segue.identifier isEqualToString:@"showEventDetails"]){
        
        Event* selectedEvent = [(ModuleEventsTableViewController *)sender getSelectedEvent];
        
        EventDetailsViewController *destination = segue.destinationViewController;
        destination.event = selectedEvent;
        
    }
    
}


@end
