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

@interface PostViewController () <UIDocumentInteractionControllerDelegate>
@property (strong, nonatomic) IBOutlet UILabel *postNameLabel;
@property (strong, nonatomic) IBOutlet UITextView *postDescriptionTextView;
@property (strong, nonatomic) IBOutlet UITableView *lectureNotesTableView;
@property (strong, nonatomic) IBOutlet UIView *slidesContainer;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *slidesHeightConstraint;
@property (strong, nonatomic) PostSlidesTableViewController *slidesTVC;

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
    
    
    [self.lectureNotesTableView sizeToFit];
    [self.lectureNotesTableView layoutIfNeeded];
    // Do any additional setup after loading the view.
    
    NSLog(@"%lu", [self.post.posts_slides count]);
}

-(void)viewDidLayoutSubviews{
        
    self.slidesHeightConstraint.constant = self.slidesTVC.tableView.contentSize.height;
    
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
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
