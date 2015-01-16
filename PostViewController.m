//
//  PostViewController.m
//  Saint Portal
//
//  Created by David Foster on 02/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "PostViewController.h"
#import "Topics.h"
#import "Modules.h"
#import "PostSlidesTableViewController.h"
#import "PostsExamplesTableViewController.h"
#import "PostTutorialsTableViewController.h"
#import "PostExercisesTableViewController.h"

@interface PostViewController () <UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *postNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *postDescriptionTextView;
@property (strong, nonatomic) IBOutlet UIView *slidesContainer;
@property (strong, nonatomic) IBOutlet UIView *examplesContainer;
@property (strong, nonatomic) IBOutlet UIView *exercisesContainer;
@property (strong, nonatomic) IBOutlet UIView *tutorialsContainer;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *slidesHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *examplesHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *exercisesHeightConstraint;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tutorialsHeightConstraint;

@property (strong, nonatomic) PostSlidesTableViewController *slidesTVC;
@property (strong, nonatomic) PostsExamplesTableViewController *examplesTVC;
@property (strong, nonatomic) PostExercisesTableViewController *exercisesTVC;
@property (strong, nonatomic) PostTutorialsTableViewController *tutorialsTVC;
@end

@implementation PostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = self.post.posts_topic.topics_module.module_code;
    
    self.postNameLabel.text = self.post.post_name;
    
    self.postDescriptionTextView.text = self.post.post_description;
    
    [self.postDescriptionTextView setFont:[UIFont systemFontOfSize:18.0f]];
    self.postDescriptionTextView.textColor = [UIColor darkGrayColor];
    [self.postDescriptionTextView sizeToFit];
    [self.postDescriptionTextView layoutIfNeeded];
    
    // Do any additional setup after loading the view.

    if([self.post.posts_slides count] == 0){
        [self.slidesContainer removeFromSuperview];
    }
    if([self.post.posts_examples count] == 0){
        [self.examplesContainer removeFromSuperview];
    }
    if([self.post.posts_exercises count] == 0){
        [self.exercisesContainer removeFromSuperview];
    }
    if([self.post.posts_tutorials count] == 0){
        [self.tutorialsContainer removeFromSuperview];
    }
    
}

-(void)viewDidLayoutSubviews{
        
    self.slidesHeightConstraint.constant = self.slidesTVC.tableView.contentSize.height;
    self.examplesHeightConstraint.constant = self.examplesTVC.tableView.contentSize.height;
    self.exercisesHeightConstraint.constant = self.exercisesTVC.tableView.contentSize.height;
    self.tutorialsHeightConstraint.constant = self.tutorialsTVC.tableView.contentSize.height;
    
    [self.view layoutIfNeeded];
    
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if([segue.identifier isEqualToString:@"slidesEmbed"]){
        
        self.slidesTVC = segue.destinationViewController;
        self.slidesTVC.post = self.post;
        
    }
    else if([segue.identifier isEqualToString:@"examplesEmbed"]){
        
        self.examplesTVC = segue.destinationViewController;
        self.examplesTVC.post = self.post;
        
    }
    else if([segue.identifier isEqualToString:@"tutorialsEmbed"]){
        
        self.tutorialsTVC = segue.destinationViewController;
        self.tutorialsTVC.post = self.post;
        
    }
    else if([segue.identifier isEqualToString:@"exercisesEmbed"]){
        
        self.exercisesTVC = segue.destinationViewController;
        self.exercisesTVC.post = self.post;
        
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
