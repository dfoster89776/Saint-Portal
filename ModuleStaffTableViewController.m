//
//  ModuleStaffTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 08/01/2015.
//  Copyright (c) 2015 David Foster. All rights reserved.
//

#import "ModuleStaffTableViewController.h"
#import "Module_Staff.h"
#import "Staff.h"
#import "StaffDetailsViewController.h"

@interface ModuleStaffTableViewController ()
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSArray *staff;
@property (nonatomic, strong) Staff* selectedStaff;
@end

@implementation ModuleStaffTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    
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

    self.staff = [self.module.staff allObjects];
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    // Return the number of rows in the section.
    return [self.staff count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"staffCell" forIndexPath:indexPath];
    
    Module_Staff *module_staff = [self.staff objectAtIndex:indexPath.row];
    Staff* staff = module_staff.staff;
    
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", staff.firstname, staff.surname];
    cell.detailTextLabel.text = module_staff.role;
    
    return cell;
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    Module_Staff *module_staff = [self.staff objectAtIndex:indexPath.row];
    
    self.selectedStaff = module_staff.staff;
    
    return indexPath;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if([segue.identifier isEqualToString:@"showStaffDetails"]){
        
        StaffDetailsViewController *destination = segue.destinationViewController;
        destination.staff = self.selectedStaff;
    }
    
    
}


@end
