//
//  ModuleTopicsTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 30/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "ModuleTopicsTableViewController.h"
#import "CurrentModulesTableViewHeader.h"
#import "Topics.h"

@interface ModuleTopicsTableViewController ()

@property (strong, nonatomic) NSArray *topics;
@property (strong, nonatomic) Topics *selectedTopic;
@end

@implementation ModuleTopicsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrentModulesTableViewHeader" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ModulesHeader"];

    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"topic_order" ascending:YES];
    
    self.topics = [[self.module.modules_topics allObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
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
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    if(section == 0){
        return 1;
    }else{
        return [self.module.modules_topics count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    if(section == 0){
        return 0;
    }else{
        return 35;
    }
    
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
 
    if(section == 0){
        return nil;
    }else{
        
        CurrentModulesTableViewHeader *headerView = [tableView dequeueReusableCellWithIdentifier:@"ModulesHeader"];
        
        if (headerView == nil){
            headerView = [[CurrentModulesTableViewHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ModulesHeader"];
        }
        
        headerView.sectionHeaderLabel.text = @"All Topics For Module";
        
        return headerView;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"viewAllTopics" forIndexPath:indexPath];
        
        return cell;
        
    }else{
        
        Topics *topic = [self.topics objectAtIndex:indexPath.row];
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"viewAllTopics" forIndexPath:indexPath];
        
        cell.textLabel.text = [NSString stringWithFormat:@"%lu.  %@", (indexPath.row + 1), topic.topic_name];
        
        return cell;
    }
    
    // Configure the cell...
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
         [self.parentViewController.parentViewController performSegueWithIdentifier:@"showAllPosts" sender:self];
    
    }else{
    
        self.selectedTopic = [self.topics objectAtIndex:indexPath.row];
    
        [self.parentViewController.parentViewController performSegueWithIdentifier:@"showTopicsPosts" sender:self];
    }
    
    
}


-(Topics *)getSelectedTopic{
    
    return self.selectedTopic;
    
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
