//
//  PreviousModulesTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 08/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "PreviousModulesTableViewController.h"
#import "AppDelegate.h"
#import "Modules.h"
#import "ModuleViewController.h"
#import "OlderModuleTableViewCell.h"
#import "CurrentModulesTableViewHeader.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

@interface PreviousModulesTableViewController ()
@property (strong, nonatomic) IBOutlet UIRefreshControl *updateEnrolledModulesRefreshIndicator;
@property (strong, nonatomic) NSManagedObjectContext *context;
@property (strong, nonatomic) NSMutableDictionary *current_modules;
@property (strong, nonatomic) NSArray *keys;
@end

@implementation PreviousModulesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self updateEnrolledModules:nil];
    
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"OlderModuleTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"OlderModuleCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"CurrentModulesTableViewHeader" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"ModulesHeader"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)updateEnrolledModules:(UIRefreshControl *)sender {
    
   
    
}

-(void)updateStatus{
    
    [self updateUI];
    [self.updateEnrolledModulesRefreshIndicator endRefreshing];
    
}

-(void)updateUI{
    
    [self.tableView reloadData];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    self.current_modules = [[NSMutableDictionary alloc] init];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Modules"];
    request.predicate = [NSPredicate predicateWithFormat:@"current = 0"];
    
    NSError *error = nil;
    
    NSArray *modules = [self.context executeFetchRequest:request error:&error];
    
    for(Modules *module in modules){
                
        if([self.current_modules objectForKey:[NSString stringWithFormat:@"%@", module.year]]){
            NSMutableArray *module_array = [self.current_modules objectForKey:[NSString stringWithFormat:@"%@", module.year]];
            [module_array addObject:module];
        }else{
            NSMutableArray *module_array = [[NSMutableArray alloc] init];
            [self.current_modules setValue:module_array forKey:[NSString stringWithFormat:@"%@", module.year]];
            [module_array addObject:module];
        }
    }
    
    // Return the number of sections.
    return [self.current_modules count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 35;
}

-(UIView *) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:@"ModulesHeader"];
    
    if (headerView == nil){
        headerView = [[CurrentModulesTableViewHeader alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ModulesHeader"];
    }
    
    int year = [[self.keys objectAtIndex:section] intValue];
    
    NSString *headerText = [NSString stringWithFormat:@"%i - %i", year, year+1];
    
    ((CurrentModulesTableViewHeader *) headerView).sectionHeaderLabel.text = headerText;
    
    return headerView;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    self.keys = [[[[self.current_modules allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] reverseObjectEnumerator] allObjects];
    
    
    
    NSArray *modules = [self.current_modules objectForKey:[self.keys objectAtIndex:section]];
    
    return [modules count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSArray *modules = [self.current_modules objectForKey:[self.keys objectAtIndex:indexPath.section]];
    
    OlderModuleTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"OlderModuleCell" forIndexPath:indexPath];
    
    Modules *module = [modules objectAtIndex:indexPath.row];
    
    if (cell == nil) {
        cell = [[OlderModuleTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"OlderModuleCell"];
    }
    
    cell.moduleCodeLabel.text = module.module_code;
    cell.moduleTitleLabel.text = module.module_name;
    
    return cell;
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"showModulesView" sender:self];
    
}



 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     NSIndexPath *path = [self.tableView indexPathForSelectedRow];
     
     NSArray *modules = [self.current_modules objectForKey:[self.keys objectAtIndex:path.section]];
     
     Modules *module = [modules objectAtIndex:path.row];
    
     ModuleViewController *destination = [segue destinationViewController];
     
     destination.moduleName = module.module_name;
     destination.module = module;
     destination.title = module.module_code;
     
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 

@end
