//
//  DashboardUpcomingCourseworkTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 24/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "DashboardUpcomingCourseworkTableViewController.h"
#import "UpcomingCourseworkTableViewCell.h"
#import "UpcomingHeaderCell.h"
#import "AppDelegate.h"
#import "Coursework.h"
#import "Modules.h"

@interface DashboardUpcomingCourseworkTableViewController ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSMutableDictionary *courseworkItems;
@property (nonatomic, strong) NSMutableArray *sections;
@property (nonatomic, strong) Coursework *selectedCourseworkItem;
@end

@implementation DashboardUpcomingCourseworkTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateTableContents:) name:@"courseworkUpdate" object:nil];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"UpcomingCourseworkTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UpcomingCourseworkCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"UpcomingHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"UpcomingHeaderCell"];
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
}

-(void)updateTableContents:(NSNotification*) notification
{
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    self.courseworkItems = [[NSMutableDictionary alloc] init];
    self.sections = [[NSMutableArray alloc] init];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coursework"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"submitted == 0"];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"coursework_due" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    
    NSArray *items = [self.context executeFetchRequest:request error:&error];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    for(Coursework *coursework in items){
                
        if([self.courseworkItems objectForKey:[df stringFromDate:coursework.coursework_due]]){
            NSMutableArray *coursework_array = [self.courseworkItems objectForKey:[df stringFromDate:coursework.coursework_due]];
            [coursework_array addObject:coursework];
            
        }else{
            NSMutableArray *coursework_array = [[NSMutableArray alloc] init];
            [self.courseworkItems setValue:coursework_array forKey:[df stringFromDate:coursework.coursework_due]];
            [coursework_array addObject:coursework];
            [self.sections addObject:[df stringFromDate:coursework.coursework_due]];
        }
        
    }
    
    // Return the number of sections.
    return [self.sections count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    NSArray *items = [self.courseworkItems objectForKey:[self.sections objectAtIndex:section]];
    
    return [items count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UpcomingCourseworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UpcomingCourseworkCell" forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[UpcomingCourseworkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UpcomingCourseworkCell"];
    }

    NSArray *courseworkForDate = [self.courseworkItems objectForKey:[self.sections objectAtIndex:indexPath.section]];
    
    Coursework *coursework = [courseworkForDate objectAtIndex:indexPath.row];
    
    cell.courseworkModuleLabel.text = coursework.assignments_module.module_code;
    cell.courseworkNameLabel.text  =coursework.coursework_name;
    
    NSDate *now = [NSDate date];
    NSDate *due = coursework.coursework_due;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *difference = [calendar components:(NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute) fromDate:now toDate:due options:0];
        
    if([difference day] > 0){
        
        cell.courseworkToGoNumberLabel.text = [NSString stringWithFormat:@"%lu", [difference day]];
        cell.courseworkToGoUnitsLabel.text = @"Days";
        
        if([difference day] < 7){
            
            cell.courseworkToGoNumberLabel.textColor = [UIColor yellowColor];
            cell.courseworkToGoUnitsLabel.textColor = [UIColor yellowColor];
            
        }else if ([difference day] < 3){
            
            cell.courseworkToGoNumberLabel.textColor = [UIColor orangeColor];
            cell.courseworkToGoUnitsLabel.textColor = [UIColor orangeColor];
        }else{
            cell.courseworkToGoNumberLabel.textColor = [UIColor darkGrayColor];
            cell.courseworkToGoUnitsLabel.textColor = [UIColor darkGrayColor];
        }
        
    }else{
        
        cell.courseworkToGoNumberLabel.textColor = [UIColor redColor];
        cell.courseworkToGoUnitsLabel.textColor = [UIColor redColor];
        
        if([difference hour] > 0){
            
            cell.courseworkToGoNumberLabel.text = [NSString stringWithFormat:@"%lu", [difference hour]];;
            cell.courseworkToGoUnitsLabel.text = @"Hours";
            
        }else{
         
            if([difference minute] > 0){
                cell.courseworkToGoNumberLabel.text = [NSString stringWithFormat:@"%lu", [difference minute]];
                cell.courseworkToGoUnitsLabel.text = @"Minutes";
            }else{
                cell.courseworkToGoNumberLabel.text = @"!";
                cell.courseworkToGoUnitsLabel.text = @"Overdue";
            }
        }
    }
    
    return cell;
}


-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UpcomingHeaderCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"UpcomingHeaderCell"];
    
    if (headerView == nil){
        headerView = [[UpcomingHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UpcomingHeaderCell"];
    }
    
    //Coursework *coursework = [self.courseworkItems objectAtIndex:section];
    
    NSString *sectionDate = [self.sections objectAtIndex:section];
    
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *date = [df dateFromString:sectionDate];
    
    [df setDateFormat:@"EEEE dd MMMM yyyy"];
    
        headerView.UpcomingCourseworkHeaderLabel.text = [df stringFromDate:date];
    
    return headerView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSArray *courseworkForDate = [self.courseworkItems objectForKey:[self.sections objectAtIndex:indexPath.section]];
    
    Coursework *coursework = [courseworkForDate objectAtIndex:indexPath.row];
    
    self.selectedCourseworkItem = coursework;
    
    [self.parentViewController.parentViewController performSegueWithIdentifier:@"showCourseworkDetails" sender:self];
}

-(Coursework *)getSelectedCourseworkItem{
    
    return self.selectedCourseworkItem;
    
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
}


- (NSString *)suffixForDayInDate:(NSDate *)date{
    NSInteger day = [[[[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian] components:NSCalendarUnitDay fromDate:date] day];
    if (day >= 11 && day <= 13) {
        return @"th";
    } else if (day % 10 == 1) {
        return @"st";
    } else if (day % 10 == 2) {
        return @"nd";
    } else if (day % 10 == 3) {
        return @"rd";
    } else {
        return @"th";
    }
}

@end
