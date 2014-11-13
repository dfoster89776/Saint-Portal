//
//  PersonalDetailsTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 12/10/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "PersonalDetailsTableViewController.h"
#import "PersonalDetailsHeaderCell.h"
#import "PersonalDetailsTableViewCell.h"
#import "Personal_Details.h"
#import "AppDelegate.h"
#import "UpdatePersonalDetailsHandler.h"

@interface PersonalDetailsTableViewController ()
@property (strong, nonatomic) UpdatePersonalDetailsHandler *updatePersonalDetailsHandler;
@property (strong, nonatomic) IBOutlet UIRefreshControl *personDetailsRefreshControl;
@property (strong, nonatomic) Personal_Details *person;
@end

@implementation PersonalDetailsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDetailsHeaderCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalDetailsHeader"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PersonalDetailsTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"PersonalDetailsInfo"];
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Personal_Details"];
    
    NSError *error = nil;
    
    NSArray *details = [context executeFetchRequest:request error:&error];
    self.person = [details firstObject];

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
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if(indexPath.row == 0){
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDetailsHeader" forIndexPath:indexPath];
        
        if(cell == nil)
        {
            cell = [[PersonalDetailsHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonalDetailsHeader"];
            
            NSLog(@"Initiated cell");
        }
        
        ((PersonalDetailsHeaderCell *) cell).studentNameLabel.text = [NSString stringWithFormat:@"%@ %@", self.person.firstname, self.person.surname];
        
    }else{
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"PersonalDetailsInfo" forIndexPath:indexPath];
        
        if(cell == nil)
        {
            cell = [[PersonalDetailsHeaderCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"PersonalDetailsInfo"];
            
            NSLog(@"Initiated cell");
        }
        
        if(indexPath.row == 1){
         
            ((PersonalDetailsTableViewCell *) cell).TitleLabel.text = @"Matriculation Number";
            ((PersonalDetailsTableViewCell *) cell).DataLabel.text = self.person.matriculation_number;
            
        }
        else if (indexPath.row == 2){
            ((PersonalDetailsTableViewCell *) cell).TitleLabel.text = @"HESA Number";
            ((PersonalDetailsTableViewCell *) cell).DataLabel.text = self.person.hesa_number;
        }
        else if (indexPath.row == 3){
            ((PersonalDetailsTableViewCell *) cell).TitleLabel.text = @"Student Support Number (SSN)";
            ((PersonalDetailsTableViewCell *) cell).DataLabel.text = self.person.student_support_number;
        }
        else if (indexPath.row == 4){
            ((PersonalDetailsTableViewCell *) cell).TitleLabel.text = @"Fee Status";
            ((PersonalDetailsTableViewCell *) cell).DataLabel.text = self.person.fee_status;
        }
        else if (indexPath.row == 5){
            ((PersonalDetailsTableViewCell *) cell).TitleLabel.text = @"Date of Birth";
            ((PersonalDetailsTableViewCell *) cell).DataLabel.text = @"16/05/1992";
        }
    }
    
    
    // Configure the cell...
    
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    if (indexPath.row == 0) {
        return 250;
    } else {
        return 101;
    }
}

- (IBAction)refreshPersonalDetails:(UIRefreshControl *)sender {
    
    self.updatePersonalDetailsHandler = [[UpdatePersonalDetailsHandler alloc] init];
    [self.updatePersonalDetailsHandler UpdatePersonalDetailsWithDelegate:self];
}

-(void)updateStatus{
    
    //Check status of personal details setup
    [self.tableView reloadData];
    [self.personDetailsRefreshControl endRefreshing];
}

-(void)APIErrorHandler:(NSError *)error{
    
    NSLog(@"Error Occcured");
    
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
