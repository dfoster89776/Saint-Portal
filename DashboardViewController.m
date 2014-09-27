//
//  DashboardViewController.m
//  Saint Portal
//
//  Created by David Foster on 22/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "DashboardViewController.h"
#import "AppDelegate.h"
#import "Personal_Details.h"

@interface DashboardViewController ()
@property (strong, nonatomic) IBOutlet UILabel *username;
@property (strong, nonatomic) IBOutlet UILabel *access_token;
@end

@implementation DashboardViewController

-(void)viewWillAppear:(BOOL)animated{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Personal_Details"];
    NSError *error;
    NSArray *details = [context executeFetchRequest:request error:&error];
    
    Personal_Details *person = [details firstObject];
    
    NSString *username = [NSString stringWithFormat:@"%@ %@", person.firstname, person.surname];
    
    [self.username setText:username];
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    NSString *access = [NSString stringWithFormat:@"%@", [prefs valueForKey:@"access_token"]];
    
    [self.access_token setText:access];
    
}
@end
