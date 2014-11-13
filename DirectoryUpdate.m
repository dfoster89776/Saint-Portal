//
//  DirectoryUpdate.m
//  Saint Portal
//
//  Created by David Foster on 13/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "DirectoryUpdate.h"
#import "AppDelegate.h"
#import "File.h"
#import "Directory.h"

@implementation DirectoryUpdate

-(void)updateExamplesDirectory:(Examples *)example withData:(NSDictionary *)data{

    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self updateDirectoriesInDirectory:example withData:[data objectForKey:@"subdirectories"] withContext:(NSManagedObjectContext *)context];
    
    [self updateFilesinDirectory:example withData:[data objectForKey:@"files"] withContext:(NSManagedObjectContext *)context];
    
    //Update directories
    
    
    NSLog(@"Example: %@", example);
    
    NSError *error;
    
    [context save:&error];
}

-(void)updateDirectory:(Directory *)directory withData:(NSDictionary *)data withContext:(NSManagedObjectContext *)context{
    
    [self updateDirectoriesInDirectory:directory withData:[data objectForKey:@"subdirectories"] withContext:(NSManagedObjectContext *)context];
    
    [self updateFilesinDirectory:directory withData:[data objectForKey:@"files"] withContext:(NSManagedObjectContext *)context];
    
}

-(void)updateFilesinDirectory:(Directory *)directory withData:(NSArray *)files withContext:(NSManagedObjectContext *)context{
    
    NSMutableArray *files_list = [[NSMutableArray alloc] init];
    
    for(NSMutableDictionary *file in files){
        
        NSLog(@"ADDING FILES: %@", [file objectForKey:@"file_url"]);
        
        [files_list addObject:[NSNumber numberWithInteger:[[file objectForKey:@"file_id"] integerValue]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"file_id == %i", [[file objectForKey:@"file_id"] integerValue]];
        
        NSSet *matches = [directory.files filteredSetUsingPredicate:predicate];
        
        if([matches count] == 0){
            
            NSLog(@"Creating new file");
            
            File *new_file = [NSEntityDescription insertNewObjectForEntityForName:@"File" inManagedObjectContext:context];
            
            new_file.file_id = [NSNumber numberWithInteger:[[file objectForKey:@"file_id"] integerValue]];
            new_file.file_url = [file objectForKey:@"file_url"];
            new_file.parentDirectory = directory;
            
            NSLog(@"%@", directory);
            
            [directory addFilesObject:new_file];
            
        }else{
            
            NSLog(@"Updating file");
            
            File *new_file = [[matches allObjects] firstObject];
            
            new_file.file_id = [NSNumber numberWithInteger:[[file objectForKey:@"file_id"] integerValue]];
            new_file.file_url = [file objectForKey:@"file_url"];
            new_file.parentDirectory = directory;
            
        }
    }
    
    
    //Remove any events not on core database
    NSArray *deletingFiles = [NSArray arrayWithArray:files_list];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (file_id IN %@)", deletingFiles];
    
    NSSet *filesToDelete = [directory.files filteredSetUsingPredicate:predicate];
    
    for(File *file in filesToDelete){
        [context deleteObject:file];
        [directory removeFilesObject:file];
    }
}

-(void)updateDirectoriesInDirectory:(Directory *)directory withData:(NSArray *)directories withContext:(NSManagedObjectContext *)context{
    
    NSMutableArray *directory_list = [[NSMutableArray alloc] init];
    
    for(NSMutableDictionary *subdirectory in directories){
        
        [directory_list addObject:[NSNumber numberWithInteger:[[subdirectory objectForKey:@"directory_id"] integerValue]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"directory_id == %i", [[subdirectory objectForKey:@"directory_id"] integerValue]];
        
        NSSet *matches = [directory.child_directories filteredSetUsingPredicate:predicate];
        
        if([matches count] == 0){
            
            Directory *new_directory = [NSEntityDescription insertNewObjectForEntityForName:@"Directory" inManagedObjectContext:context];
            
            new_directory.directory_id = [NSNumber numberWithInteger:[[subdirectory objectForKey:@"directory_id"] integerValue]];
            new_directory.parent_directory = directory;
            new_directory.name = [subdirectory objectForKey:@"directory_name"];
            
            DirectoryUpdate *du = [[DirectoryUpdate alloc] init];
            [du updateDirectory:new_directory withData:subdirectory withContext:context];
            
            [directory addChild_directoriesObject:new_directory];
            
        }else{
            
            Directory *new_directory = [[matches allObjects] firstObject];
            
            new_directory.directory_id = [NSNumber numberWithInteger:[[subdirectory objectForKey:@"directory_id"] integerValue]];
            new_directory.parent_directory = directory;
            new_directory.name = [subdirectory objectForKey:@"directory_name"];
            
            DirectoryUpdate *du = [[DirectoryUpdate alloc] init];
            [du updateDirectory:new_directory withData:subdirectory withContext:context];
            
        }
    }
    
    //Remove any events not on core database
    NSArray *deletingFiles = [NSArray arrayWithArray:directory_list];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (file_id IN %@)", deletingFiles];
    
    NSSet *filesToDelete = [directory.files filteredSetUsingPredicate:predicate];
    
    for(File *file in filesToDelete){
        [context deleteObject:file];
        [directory removeFilesObject:file];
    }
    
}



@end
