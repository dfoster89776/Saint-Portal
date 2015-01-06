//
//  DashboardUpcomingEventsTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 26/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "DashboardUpcomingEventsTableViewController.h"
#import "UpcomingHeaderCell.h"
#import "ModuleEventTableViewCell.h"
#import "AppDelegate.h"
#import "Event.h"
#import "Modules.h"
#import "Buildings.h"
#import "Rooms.h"

@interface DashboardUpcomingEventsTableViewController ()
@property (strong, nonatomic) NSArray *todayEvents;
@property (strong, nonatomic) NSArray *tomorrowEvents;
@property (strong, nonatomic) NSManagedObjectContext *context;
@end

@implementation DashboardUpcomingEventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    [self.tableView registerNib:[UINib nibWithNibName:@"UpcomingHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UpcomingHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ModuleEventTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ModuleEventCell"];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //Get today's events
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Event"];
    
    NSDate *now = [NSDate date];
    NSDate *midnight = [self dateAtBeginningOfDayForDate:[NSDate dateWithTimeIntervalSinceNow:86400]];
    NSDate *midnightTomorrow = [self dateAtBeginningOfDayForDate:[NSDate dateWithTimeIntervalSinceNow:172800]];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(end_time >= %@) AND (start_time <= %@)", now, midnight];
    
    NSError *error = nil;
    
    self.todayEvents = [self.context executeFetchRequest:request error:&error];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(end_time >= %@) AND (start_time <= %@)", midnight, midnightTomorrow];
    
    self.tomorrowEvents = [self.context executeFetchRequest:request error:&error];
        
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if(section == 0){
        if([self.todayEvents count] == 0){
            return 1;
        }else{
            return [self.todayEvents count];
        }
    }else{
        if([self.tomorrowEvents count] == 0){
            return 1;
        }else{
            return [self.tomorrowEvents count];
        }
    }
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UpcomingHeaderCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"UpcomingHeaderCell"];
    
    if (headerView == nil){
        headerView = [[UpcomingHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UpcomingHeaderCell"];
    }
    
    if(section == 0){
        headerView.UpcomingCourseworkHeaderLabel.text = @"Today";
    }else if (section == 1){
        headerView.UpcomingCourseworkHeaderLabel.text = @"Tomorrow";
        
    }
    
    return headerView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        if([self.todayEvents count] == 0){
            return 70;
        }else{
            return 100;        }
    }else{
        if([self.tomorrowEvents count] == 0){
            return 70;
        }else{
            return 100;
        }
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    
    if(indexPath.section == 0){
        if([self.todayEvents count] == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoEventsTodayCell" forIndexPath:indexPath];
            return cell;
        }else{
            ModuleEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModuleEventCell" forIndexPath:indexPath];
            
            if(cell == nil)
            {
                cell = [[ModuleEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ModuleEventCell"];
            }
            
            Event *event = [self.todayEvents objectAtIndex:indexPath.row];
            
            cell.eventModuleLabel.text = event.event_module.module_code;
            cell.eventStartTimeLabel.text = [df stringFromDate:event.start_time];
            cell.eventEndTimeLabel.text = [df stringFromDate:event.end_time];
            
            cell.eventTypeLabel.text = event.event_type;
            
            cell.eventBuildingLabel.text = event.event_location.room_name;
            cell.eventRoomLabel.text = event.event_location.rooms_building.building_name;
            
            return cell;

        }
    }else{
        if([self.tomorrowEvents count] == 0){
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoEventsTomorrowCell" forIndexPath:indexPath];
            return cell;
        }else{
            ModuleEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModuleEventCell" forIndexPath:indexPath];
            
            if(cell == nil)
            {
                cell = [[ModuleEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ModuleEventCell"];
            }
            
            Event *event = [self.tomorrowEvents objectAtIndex:indexPath.row];
            
            cell.eventModuleLabel.text = event.event_module.module_code;
            cell.eventStartTimeLabel.text = [df stringFromDate:event.start_time];
            cell.eventEndTimeLabel.text = [df stringFromDate:event.end_time];
            
            cell.eventTypeLabel.text = event.event_type;
            
            NSLog(@"ROOM NUMBER: %@", event.event_location.location_id);

            cell.eventBuildingLabel.text = event.event_location.room_name;
            cell.eventRoomLabel.text = event.event_location.rooms_building.building_name;
            
            return cell;

        }
    }
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

- (NSDate *)dateAtBeginningOfDayForDate:(NSDate *)inputDate
{
    // Use the user's current calendar and time zone
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    [calendar setTimeZone:timeZone];
    
    // Selectively convert the date components (year, month, day) of the input date
    NSDateComponents *dateComps = [calendar components:NSCalendarUnitYear  | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:inputDate];
    
    // Set the time components manually
    [dateComps setHour:0];
    [dateComps setMinute:0];
    [dateComps setSecond:0];
    
    // Convert back
    NSDate *beginningOfDay = [calendar dateFromComponents:dateComps];
    return beginningOfDay;
}

@end
