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


@interface ModuleViewController ()
@property (strong, nonatomic) IBOutlet UILabel *moduleNameLabel;
@end

@implementation ModuleViewController
@synthesize moduleName;

- (void)viewDidLoad {
    [super viewDidLoad];

    self.moduleNameLabel.text = [NSString stringWithFormat:@"%lu", [self.module.module_events count]];
    
    // Do any additional setup after loading the view.
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
        
    }
    
}


@end
