//
//  MoreTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 23/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "MoreTableViewController.h"
#import "AppDelegate.h"

@interface MoreTableViewController ()

@end

@implementation MoreTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    NSLog(@"Segueing");

}


#pragma mark - Logout

-(void) logout{
    
    //Clear persistent store
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] clearPersistentStore];
    
    //Remove NSUserDefault preferences - Access token
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"access_token"];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *homeScreenVC = [storyboard instantiateViewControllerWithIdentifier:@"Login"];
    
    [[self view] window].rootViewController = homeScreenVC;
        
}

@end
