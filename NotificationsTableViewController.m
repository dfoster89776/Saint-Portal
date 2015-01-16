//
//  NotificationsTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 11/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "NotificationsTableViewController.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"
#import "Notification.h"
#import "UpdateNotificationsListHandler.h"
#import "NotificationTableViewCell.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

@interface NotificationsTableViewController () <UpdateNotificationsDelegate>
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong)NSArray* notifications;
@end

@implementation NotificationsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableData:) name:@"NotificationsUpdate" object:nil];
    
    self.tableView.estimatedRowHeight = 44.0;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    
    [self refreshNotificationList:nil];
    
    [self updateTableData:nil];
}

-(void)updateTableData:(NSNotification*) notification{
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notification"];
    request.sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"received" ascending:NO]];
    
    NSError* error;
    self.notifications = [self.context executeFetchRequest:request error:&error];
    
    [self.tableView reloadData];
    
}
- (IBAction)refreshNotificationList:(id)sender {

    UpdateNotificationsListHandler *unlh = [[UpdateNotificationsListHandler alloc] init];
    [unlh updateNotificationsWithDelegate:self];

}

-(void)notificationsUpdateSuccess{
    
    [self.refreshControl endRefreshing];
    [self updateTableData:nil];
    
}

-(void)notificationsUpdateFailure:(NSError *)error{
    
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
    return [self.notifications count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Notification" forIndexPath:indexPath];
    
    Notification* notification = [self.notifications objectAtIndex:indexPath.row];
    
    cell.notificationMessageLabel.text = notification.message;
    
    
    if(![notification.read boolValue]){
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
        view.backgroundColor = UIColorFromRGB(0x00AEEF);
        
        CAShapeLayer *shape = [CAShapeLayer layer];
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:view.center radius:(view.bounds.size.width / 2) startAngle:0 endAngle:(2 * M_PI) clockwise:YES];
        shape.path = path.CGPath;
        view.layer.mask=shape;
        
        [cell.notificationReadView addSubview:view];
        
    }else{
        [[cell.notificationReadView subviews]
         makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if(notification.type == nil){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return cell;
}

- (IBAction)markAllNotificationsAsRead:(id)sender {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Notification"];
    request.predicate = [NSPredicate predicateWithFormat:@"read == 0"];
    
    NSError *error;
    
    NSArray *unreadNotifications = [self.context executeFetchRequest:request error:&error];
    
    for(Notification* notification in unreadNotifications){
        
        notification.read = [NSNumber numberWithBool:YES];
        
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsUpdate" object:nil];
    
    [self updateTableData:nil];
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Notification* notification = [self.notifications objectAtIndex:indexPath.row];
    
    
    
    if(notification.type != nil){
        
        if([notification.type isEqualToString:@"coursework"]){
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] displayCourseworkItemWithId:notification.linked_id];
            
        }
        
        else if([notification.type isEqualToString:@"event"]){
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] displayEventItemWithId:notification.linked_id];
            
        }
        
        else if([notification.type isEqualToString:@"post"]){
            
            [(AppDelegate *)[[UIApplication sharedApplication] delegate] displayPostItemWithId:notification.linked_id];
            
        }
        
    }
    
    notification.read = [NSNumber numberWithBool:YES];
        
    [(AppDelegate *)[[UIApplication sharedApplication] delegate] saveContext];
    
    [self.tableView reloadData];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NotificationsUpdate" object:nil];

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
