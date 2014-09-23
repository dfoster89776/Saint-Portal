//
//  DashboardViewController.m
//  Saint Portal
//
//  Created by David Foster on 22/09/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "DashboardViewController.h"

@interface DashboardViewController ()
@property (strong, nonatomic) IBOutlet UILabel *username;
@end

@implementation DashboardViewController

-(void)viewWillAppear:(BOOL)animated{
    
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    NSObject * object = [prefs objectForKey:@"username"];
    
    NSString *username = (NSString *)object;
    
    [self.username setText:username];
    
}
@end
