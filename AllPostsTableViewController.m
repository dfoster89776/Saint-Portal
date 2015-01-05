//
//  AllPostsTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 03/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "AllPostsTableViewController.h"
#import "Topics.h"
#import "Posts.h"
#import "CurrentModulesTableViewHeader.h"
#import "PostViewController.h"

@interface AllPostsTableViewController ()
@property (strong, nonatomic) NSArray *topics;
@property (strong, nonatomic) Posts* selectedPost;
@end

@implementation AllPostsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrentModulesTableViewHeader" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ModulesHeader"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableContents:) name:@"postUpdate" object:nil];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)updateTableContents:(NSNotification*) notification{
    
    NSLog(@"Reloading table data");
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"topic_order" ascending:YES];
    
    self.topics = [[self.module.modules_topics allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    // Return the number of sections.
    return [self.topics count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    Topics *topic = [self.topics objectAtIndex:section];
    
    return [topic.topics_posts count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"ModulesHeader"];
    
    if (headerView == nil){
        headerView = [[CurrentModulesTableViewHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ModulesHeader"];
    }
    
    Topics *topic = [self.topics objectAtIndex:section];
    
    ((CurrentModulesTableViewHeader *) headerView).sectionHeaderLabel.text = [NSString stringWithFormat:@"%lu. %@", (section + 1), topic.topic_name];
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"post_order" ascending:YES];
    
    Topics *topic = [self.topics objectAtIndex:indexPath.section];
    
    NSArray *posts = [[NSArray alloc] init];
    
    posts = [[topic.topics_posts allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    Posts *post = [posts objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PostCell" forIndexPath:indexPath];
    
    // Configure the cell...
    
    cell.textLabel.text = post.post_name;
    
    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"post_order" ascending:YES];
    
    Topics *topic = [self.topics objectAtIndex:indexPath.section];
    
    NSArray *posts = [[NSArray alloc] init];
    
    posts = [[topic.topics_posts allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    self.selectedPost = [posts objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"showPostDetails" sender:self];
    
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    PostViewController *destination = segue.destinationViewController;
    
    destination.post = self.selectedPost;
    
}


@end
