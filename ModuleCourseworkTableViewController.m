//
//  ModuleCourseworkTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 16/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "ModuleCourseworkTableViewController.h"
#import "ModuleCourseworkTableViewCell.h"
#import "CurrentModulesTableViewHeader.h"

@interface ModuleCourseworkTableViewController ()
@property (strong, nonatomic) NSArray *coursework_items;
@property (strong, nonatomic) Coursework *selectedCourseworkItem;
@property (strong, nonatomic) NSArray *futureCoursework;
@property (strong, nonatomic) NSArray *pastCoursework;
@end

@implementation ModuleCourseworkTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ModuleCourseworkTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ModuleCourseworkCell"];
        [self.tableView registerNib:[UINib nibWithNibName:@"CurrentModulesTableViewHeader" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ModulesHeader"];
        
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"submitted == 0"];
    self.futureCoursework = [[self.module.module_assignments allObjects] filteredArrayUsingPredicate:pred];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"coursework_due" ascending:YES];
    
    self.futureCoursework = [self.futureCoursework sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
    pred = [NSPredicate predicateWithFormat:@"submitted == 1"];
    self.pastCoursework = [[self.module.module_assignments allObjects] filteredArrayUsingPredicate:pred];
    self.pastCoursework = [self.pastCoursework
                           sortedArrayUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if ([self.pastCoursework count] == 0){
        return 1;
    }else if ([self.futureCoursework count] == 0){
        return 1;
    }else{
        return 2;
    }
    
    // Return the number of sections.
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"ModulesHeader"];
    
    if (headerView == nil){
        headerView = [[CurrentModulesTableViewHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ModulesHeader"];
    }
    
    NSString *headerText;
    
    if([self.pastCoursework count] == 0){
       headerText = @"Due Coursework";
    }
    else if([self.futureCoursework count] == 0){
        headerText = @"Complete Coursework";
    }else if(([self.pastCoursework count] == 0) && ([self.futureCoursework count] == 0)){
        headerText = nil;
    }else{
        
        if(section == 0){
            headerText = @"Upcoming Coursework";
        }
        else{
            headerText = @"Completed Coursework";
        }
        
    }
    
    ((CurrentModulesTableViewHeader *) headerView).sectionHeaderLabel.text = headerText;
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    if(section == 0){
        if([self.futureCoursework count] > 0){
            return [self.futureCoursework count];
        }else{
            return [self.pastCoursework count];
        }
    }else{
        return [self.pastCoursework count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return 150;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ModuleCourseworkTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModuleCourseworkCell" forIndexPath:indexPath];
    
    if(cell == nil)
    {
        cell = [[ModuleCourseworkTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ModuleCourseworkCell"];
    }
    
    Coursework *currentCoursework;
    
    if(indexPath.section == 0){
        
        if([self.futureCoursework count] > 0){
            currentCoursework = [self.futureCoursework objectAtIndex:indexPath.row];
        }else{
            currentCoursework = [self.pastCoursework objectAtIndex:indexPath.row];
        }
    }else{
        currentCoursework = [self.pastCoursework objectAtIndex:indexPath.row];
    }
        
    // Configure the cell...
    cell.CourseworkNameLabel.text = currentCoursework.coursework_name;
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"HH:mm:ss"];

    cell.courseworkDueTimeLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:currentCoursework.coursework_due]];
    
    [df setDateFormat:@"EEEE dd MMMM YYYY"];
    
    cell.CourseworkDueDateLabel.text = [NSString stringWithFormat:@"%@",[df stringFromDate:currentCoursework.coursework_due]];
    
    cell.weightingLabel.text = [NSString stringWithFormat:@"Weighting: %@%%", currentCoursework.coursework_weighting];
    
    int completed = [currentCoursework.submitted intValue];
    
    if(!completed){
    
        NSDate *now = [NSDate date];
        NSDate *due = currentCoursework.coursework_due;
        
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
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 0){
        
        if([self.futureCoursework count] > 0){
            self.selectedCourseworkItem = [self.futureCoursework objectAtIndex:indexPath.row];
        }else{
            self.selectedCourseworkItem = [self.pastCoursework objectAtIndex:indexPath.row];
        }
    }else{
        self.selectedCourseworkItem = [self.pastCoursework objectAtIndex:indexPath.row];
    }
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
