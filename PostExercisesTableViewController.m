//
//  PostExercisesTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 15/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "PostExercisesTableViewController.h"
#import "Exercises.h"
#import "OpenStoreHandler.h"


@interface PostExercisesTableViewController ()
@property (strong, nonatomic) NSArray *exercises;
@end

@implementation PostExercisesTableViewController

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
    
    self.exercises = [self.post.posts_exercises allObjects];
    
    return [self.exercises count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Exercises *exercise = [self.exercises objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StandardCell" forIndexPath:indexPath];
    
    cell.textLabel.text = exercise.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Exercises *exercise = [self.exercises objectAtIndex:indexPath.row];
    
    OpenStoreHandler *osh = [[OpenStoreHandler alloc] init];
    
    [osh openDirectory:exercise withCurrentView:self.parentViewController];
    
    
    
}

@end
