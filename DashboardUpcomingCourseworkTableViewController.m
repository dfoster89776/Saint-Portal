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
    
    NSDateComponents *dayComponent = [[NSDateComponents alloc] init];
    dayComponent.day = 14;
    
    NSCalendar *theCalendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDate *nextDate = [theCalendar dateByAddingComponents:dayComponent toDate:now options:0];
    
    self.courseworkItems = [[NSMutableDictionary alloc] init];
    self.sections = [[NSMutableArray alloc] init];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coursework"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"(coursework_due < %@) && ((coursework_due > %@) || (submitted == 0))", nextDate, now];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"coursework_due" ascending:YES];
    
    request.sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    NSError *error = nil;
    
    NSArray *items = [self.context executeFetchRequest:request error:&error];
    
    if([items count] == 0){
        return 1;
    }
    
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
    
    if([self.sections count] == 0){
        return 1;
    }
    
    NSArray *items = [self.courseworkItems objectForKey:[self.sections objectAtIndex:section]];
    
    return [items count];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.sections count] == 0){
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoUpcomingCourseworkCell" forIndexPath:indexPath];
        return cell;
    }
    
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
        
        if ([difference day] < 3){
            
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
    if([self.sections count] == 0){
        headerView.UpcomingCourseworkHeaderLabel.text = @"Next 14 Days";
    }else{
    
        NSString *sectionDate = [self.sections objectAtIndex:section];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd"];
        
        NSDate *date = [df dateFromString:sectionDate];
        
        [df setDateFormat:@"EEEE dd MMMM yyyy"];
        
        headerView.UpcomingCourseworkHeaderLabel.text = [df stringFromDate:date];
    }
    return headerView;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 35;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.sections count] == 0){
        return 70;
    }
    
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
