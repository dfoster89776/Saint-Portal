//
//  MoreTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 23/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "MoreTableViewController.h"
#import "AppDelegate.h"
#import "MoreViewHeaderTableViewCell.h"

@interface MoreTableViewController ()

@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MoreViewHeaderTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"MoreViewHeader"];
    
}



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    //Personal Details
    if((indexPath.section == 0) && (indexPath.row == 0)){
        
    }else if((indexPath.section == 0) && (indexPath.row == 1)){
        [self performSegueWithIdentifier: @"Show Student Record" sender: self];
    }
    
    //Logout
    else if((indexPath.section == 1) && (indexPath.row == 0)){
        [self logout];
    }
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    MoreViewHeaderTableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"MoreViewHeader"];
    
    if (headerView == nil){
        headerView = [[MoreViewHeaderTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MoreViewHeader"];
    }
    
    if(section == 0){
        headerView.headerLabel.text = @"Student Record";
    }else{
        headerView.headerLabel.text = @"Settings";
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
    return 35;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

}


#pragma mark - Logout

-(void) logout{
    
    NSLog(@"Logged out");
    
    //Clear persistent store
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] clearPersistentStore];
    
    //Remove NSUserDefault preferences - Access token
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *homeScreenVC = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    
    [[self view] window].rootViewController = homeScreenVC;
        
}

@end
