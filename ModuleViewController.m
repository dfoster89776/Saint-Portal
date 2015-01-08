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


@interface ModuleViewController ()
@property (strong, nonatomic) IBOutlet UIView *pageLabelViewContainer;
@end

@implementation ModuleViewController
@synthesize moduleName;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Staff"];
    
    //request.predicate = [NSPredicate predicateWithFormat:@"staff_id == %i", [[data objectForKey:@"staff_id"] integerValue]];
    
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest:request error:&error];
    
    NSLog(@"STAFF COUNT: %lu : %lu", count, (unsigned long)[self.module.staff count]);
    
    //NSLog(@"View width: %f", self.view.frame.size.width);
    
    /*
    int height = self.pageLabelViewContainer.frame.size.height;
    
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 375, height)];
    titleView.backgroundColor = [UIColor greenColor];
    
    [self.pageLabelViewContainer addSubview:titleView];
    */
                         
                         
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    
    NSLog(@"Frame width: %f", self.pageLabelViewContainer.frame.size.width);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)segueToCourseworkViewFor:(Coursework *)coursework{
    
    
    
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
    }
    
}


@end
