//
//  PostTutorialsTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 15/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "PostTutorialsTableViewController.h"
#import "OpenStoreHandler.h"
#import "Tutorial.h"

@interface PostTutorialsTableViewController ()
@property (nonatomic, strong) NSArray* tutorials;
@end

@implementation PostTutorialsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    self.tutorials = [self.post.posts_tutorials allObjects];
    
    // Return the number of rows in the section.
    return [self.tutorials count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StandardCell" forIndexPath:indexPath];
    
    Tutorial *tutorial = [self.tutorials objectAtIndex:indexPath.row];
        
    cell.textLabel.text = tutorial.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OpenStoreHandler *osh = [[OpenStoreHandler alloc] init];
    
    [osh openFile:[self.tutorials objectAtIndex:indexPath.row] withCurrentView:self.parentViewController];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
