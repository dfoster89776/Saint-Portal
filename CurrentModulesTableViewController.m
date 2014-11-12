//
//  CurrentModulesTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 07/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "CurrentModulesTableViewController.h"
#import "AppDelegate.h"
#import "Modules.h"
#import "ModuleViewController.h"
#import "ModuleTableViewCell.h"
#import "CurrentModulesTableViewHeader.h"

#import "UpdateAllModuleData.h"

@interface CurrentModulesTableViewController () <UpdateAllModuleDataDelegate>
@property (strong, nonatomic) IBOutlet UIRefreshControl *updateEnrolledModulesRefreshIndicator;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSMutableDictionary *current_modules;
@property (strong, nonatomic) NSArray *keys;

@end

@implementation CurrentModulesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateEnrolledModules:nil];
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ModuleTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ModuleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrentModulesTableViewHeader" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ModulesHeader"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateEnrolledModules:(UIRefreshControl *)sender {
    
    UpdateAllModuleData *umd = [[UpdateAllModuleData alloc] init];
    [umd updateAllModuleDataWithDelegate:self];
    
}

-(void)updateAllModuleDataSuccess{
    NSLog(@"All Module Data Update Success");
    
    [self updateStatus];
}

-(void)updateAllModuleDataFailure:(NSError *)error{
    NSLog(@"Module Data Update Failure");
}

-(void)updateStatus{
    
    [self.tableView reloadData];
    [self.updateEnrolledModulesRefreshIndicator endRefreshing];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    self.current_modules = [[NSMutableDictionary alloc] init];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Modules"];
    request.predicate = [NSPredicate predicateWithFormat:@"current = 1"];
    
    NSError *error = nil;
    
    NSArray *modules = [self.context executeFetchRequest:request error:&error];
    
    for(Modules *module in modules){
        
        if([self.current_modules objectForKey:[NSString stringWithFormat:@"%@", module.semester]]){
            NSMutableArray *module_array = [self.current_modules objectForKey:[NSString stringWithFormat:@"%@", module.semester]];
            [module_array addObject:module];
        }else{
            NSMutableArray *module_array = [[NSMutableArray alloc] init];
            [self.current_modules setValue:module_array forKey:[NSString stringWithFormat:@"%@", module.semester]];
            [module_array addObject:module];
        }
    }
    // Return the number of sections.
    return [self.current_modules count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.keys = [[self.current_modules allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    NSArray *modules = [self.current_modules objectForKey:[self.keys objectAtIndex:section]];
    
    return [modules count];

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
    
    if([[self.keys objectAtIndex:section] isEqualToString:@"S1"]){
        headerText = @"Semester 1";
    }else if([[self.keys objectAtIndex:section] isEqualToString:@"S2"]){
        headerText = @"Semester 2";
    }else{
        headerText = @"Whole Year";
    }
    
    ((CurrentModulesTableViewHeader *) headerView).sectionHeaderLabel.text = headerText;
    
    return headerView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *modules = [self.current_modules objectForKey:[self.keys objectAtIndex:indexPath.section]];
    
    ModuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ModuleCell" forIndexPath:indexPath];
    
    Modules *module = [modules objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[ModuleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ModuleCell"];
    }
    
    cell.moduleCodeLabel.text = module.module_code;
    cell.moduleNameLabel.text = module.module_name;
    
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"showModulesView" sender:self];
    
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([segue.identifier isEqualToString:@"showPreviousModules"]) {
        
    }else if ([segue.identifier isEqualToString:@"showModulesView"]) {
     
        NSIndexPath *path = [self.tableView indexPathForSelectedRow];
        
        NSArray *modules = [self.current_modules objectForKey:[self.keys objectAtIndex:path.section]];
        
        Modules *module = [modules objectAtIndex:path.row];
        
        ModuleViewController *destination = [segue destinationViewController];
        
        destination.moduleName = module.module_name;
        destination.module = module;
        destination.title = module.module_code;
        
    }

}


@end
