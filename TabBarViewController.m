//
//  TabBarViewController.m
//  Saint Portal
//
//  Created by David Foster on 11/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "TabBarViewController.h"
#import "AppDelegate.h"

@interface TabBarViewController ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@end

@implementation TabBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSLog(@"Tab bar did load");
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateBadgeCount:) name:@"NotificationsUpdate" object:nil];
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self updateBadgeCount:nil];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateBadgeCount:(NSNotification *)notification{
    
    NSLog(@"Updating badge count");
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notification"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"read == NO"];
    
    NSError *error;
    
    
    
    int count = (int)[self.context countForFetchRequest:request error:&error];
    NSLog(@"%@", error.userInfo);
    NSLog(@"Count: %i", count);
    
    UITabBarItem *tbItem = [self.tabBar.items objectAtIndex:2];
    
    if(count > 0){
    
        tbItem.badgeValue = [NSString stringWithFormat:@"%i", count];
    }else{
        
        tbItem.badgeValue = nil;
        
    }
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
