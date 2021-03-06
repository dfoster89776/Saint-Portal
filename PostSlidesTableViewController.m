//
//  PostSlidesTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 11/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "PostSlidesTableViewController.h"
#import "OpenStoreHandler.h"

@interface PostSlidesTableViewController ()
@property (nonatomic, strong) NSArray* slides;
@end

@implementation PostSlidesTableViewController

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
    
    self.slides = [self.post.posts_slides allObjects];
    
    // Return the number of rows in the section.
    return [self.slides count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"StandardCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    Slides *slide = [self.slides objectAtIndex:indexPath.row];
    
    cell.textLabel.text = slide.name;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    OpenStoreHandler *osh = [[OpenStoreHandler alloc] init];
    
    [osh openFile:[self.slides objectAtIndex:indexPath.row] withCurrentView:self.parentViewController];
    
}


@end
