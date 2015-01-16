//
//  ModuleEventsTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 15/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "ModuleEventsTableViewController.h"
#import "ModuleEventTableViewCell.h"
#import "Rooms.h"
#import "Buildings.h"
#import "UpcomingHeaderCell.h"

@interface ModuleEventsTableViewController ()
@property (nonatomic, strong) NSMutableDictionary *eventItems;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) Event* selectedEvent;
@end

@implementation ModuleEventsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UpcomingHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UpcomingHeaderCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"ModuleEventTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ModuleEventCell"];
    
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
    
    self.eventItems = [[NSMutableDictionary alloc] init];
    self.sections = [[NSMutableArray alloc] init];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE, d MMM yyyy"];
    
    NSArray *events = [self.module.module_events allObjects];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"start_time" ascending:YES];
    
    events = [events sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    for(Event *event in events){
        
        if([self.eventItems objectForKey:[df stringFromDate:event.start_time]]){
            NSMutableArray *event_array = [self.eventItems objectForKey:[df stringFromDate:event.start_time]];
            [event_array addObject:event];
        }else{
            NSMutableArray *event_array = [[NSMutableArray alloc] init];
            [self.eventItems setValue:event_array forKey:[df stringFromDate:event.start_time]];
            [event_array addObject:event];
            [self.sections addObject:[df stringFromDate:event.start_time]];
        }
    }
    
    
    
    // Return the number of sections.
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSArray *items = [self.eventItems objectForKey:[self.sections objectAtIndex:section]];
    
    return [items count];

}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UpcomingHeaderCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"UpcomingHeaderCell"];
    
    if (headerView == nil){
        headerView = [[UpcomingHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UpcomingHeaderCell"];
    }
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"EEE, d MMM yyyy"];
    
    headerView.UpcomingCourseworkHeaderLabel.text = [self.sections objectAtIndex:section];
    
    return headerView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm"];
    
    ModuleEventTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModuleEventCell" forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[ModuleEventTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ModuleEventCell"];
    }
    
    NSArray *eventsForDate = [self.eventItems objectForKey:[self.sections objectAtIndex:indexPath.section]];
    
    Event *event = [eventsForDate objectAtIndex:indexPath.row];
    
    if(([event.start_time compare:[NSDate date]] == NSOrderedAscending) && ([event.end_time compare:[NSDate date]] == NSOrderedDescending)){
        
        [cell.eventStartTimeLabel setHidden:true];
        [cell.eventEndTimeLabel setHidden:true];
        [cell.eventNowLabel setHidden:false];
    }else{
        cell.eventStartTimeLabel.text = [df stringFromDate:event.start_time];
        cell.eventEndTimeLabel.text = [df stringFromDate:event.end_time];
        [cell.eventStartTimeLabel setHidden:false];
        [cell.eventEndTimeLabel setHidden:false];
        [cell.eventNowLabel setHidden:true];
    }
    
    cell.eventModuleLabel.text = event.event_module.module_code;
    
    
    cell.eventTypeLabel.text = [event.event_type stringByReplacingCharactersInRange:NSMakeRange(0,1)
                                                                         withString:[[event.event_type substringToIndex:1] capitalizedString]];
    
    cell.eventBuildingLabel.text = event.event_location.room_name;
    cell.eventRoomLabel.text = event.event_location.rooms_building.building_name;
        
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 
    NSArray *eventsForDate = [self.eventItems objectForKey:[self.sections objectAtIndex:indexPath.section]];
    
    self.selectedEvent = [eventsForDate objectAtIndex:indexPath.row];
    
    [self.parentViewController.parentViewController performSegueWithIdentifier:@"showEventDetails" sender:self];
    
}

-(Event *)getSelectedEvent{
    return self.selectedEvent;
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
