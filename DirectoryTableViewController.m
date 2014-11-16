//
//  DirectoryTableViewController.m
//  Saint Portal
//
//  Created by David Foster on 13/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "DirectoryTableViewController.h"
#import "File.h"
#import "Directory.h"
#import "OpenStoreHandler.h"
#import "FileTableViewCell.h"
#import "DirectoryTableViewCell.h"

@interface DirectoryTableViewController ()
@property (strong, nonatomic) NSArray* files;
@property (strong, nonatomic) NSArray* directories;
@end

@implementation DirectoryTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"DirectoryTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"directoryCell"];
    
     [self.tableView registerNib:[UINib nibWithNibName:@"FileTableViewCell" bundle:[NSBundle mainBundle]] forCellReuseIdentifier:@"fileCell"];
    
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

    self.files = [self.directory.files allObjects];
    self.directories = [self.directory.child_directories allObjects];
    
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
        
    if(section == 1){
        return [self.files count];
    }else{
        return [self.directories count];
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell;
    
    if(indexPath.section == 1){
     
        FileTableViewCell *fileCell = [tableView dequeueReusableCellWithIdentifier:@"fileCell" forIndexPath:indexPath];
        
        if(fileCell == nil)
        {
            fileCell = [[FileTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"fileCell"];
        }
        
        File *file = [self.files objectAtIndex:indexPath.row];
        
        fileCell.fileNameLabel.text = file.file_name;
        
        cell = fileCell;
        
    }else if (indexPath.section == 0){
        
        DirectoryTableViewCell *directoryCell = [tableView dequeueReusableCellWithIdentifier:@"directoryCell" forIndexPath:indexPath];
        
        if(directoryCell == nil)
        {
            directoryCell = [[DirectoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"directoryCell"];
        }
        
        Directory *directory = [self.directories objectAtIndex:indexPath.row];
        
        directoryCell.directoryNameLabel.text = directory.name;
        
        cell = directoryCell;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section == 1){
        
        File *file = [self.files objectAtIndex:indexPath.row];
        
        OpenStoreHandler *osh = [[OpenStoreHandler alloc] init];
        
        [osh openFile:file withCurrentView:self];
        
    }else if (indexPath.section == 0){
     
        Directory *directory = [self.directories objectAtIndex:indexPath.row];
        
        OpenStoreHandler *osh = [[OpenStoreHandler alloc] init];
        
        [osh openDirectory:directory withCurrentView:self];
        
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

@end
