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
    
    
    NSError *error;
    
    [context save:&error];
}

-(void)updateCourseworkDirectory:(Coursework_Directory *)directory withData:(NSDictionary *)data{
    
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    [self updateDirectoriesInDirectory:directory withData:[data objectForKey:@"subdirectories"] withContext:(NSManagedObjectContext *)context];
    
    [self updateFilesinDirectory:directory withData:[data objectForKey:@"files"] withContext:(NSManagedObjectContext *)context];
    
    
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
        
        //NSLog(@"ADDING FILES: %@", [file objectForKey:@"file_url"]);
        
        [files_list addObject:[NSNumber numberWithInteger:[[file objectForKey:@"file_id"] integerValue]]];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"file_id == %i", [[file objectForKey:@"file_id"] integerValue]];
        
        NSSet *matches = [directory.files filteredSetUsingPredicate:predicate];
        
        NSDateFormatter *df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        if([matches count] == 0){
            
            //NSLog(@"Creating new file");
            
            File *new_file = [NSEntityDescription insertNewObjectForEntityForName:@"File" inManagedObjectContext:context];
            
            new_file.file_id = [NSNumber numberWithInteger:[[file objectForKey:@"file_id"] integerValue]];
            new_file.file_url = [file objectForKey:@"file_url"];
            new_file.parentDirectory = directory;
            
            NSArray *parts = [new_file.file_url componentsSeparatedByString:@"/"];
            new_file.file_name = [parts lastObject];
            
            if(new_file.downloaded){
                
                NSDate *updated = [df dateFromString:[file objectForKey:@"last_modified"]];
                
                if(updated > new_file.downloaded){
                    new_file.update_available = [NSNumber numberWithInt:1];
                }
            }
            
            //NSLog(@"%@", directory);
            
            [directory addFilesObject:new_file];
            
        }else{
            
            //NSLog(@"Updating file");
            
            File *new_file = [[matches allObjects] firstObject];
            
            new_file.file_id = [NSNumber numberWithInteger:[[file objectForKey:@"file_id"] integerValue]];
            new_file.file_url = [file objectForKey:@"file_url"];
            new_file.parentDirectory = directory;
            
            NSArray *parts = [new_file.file_url componentsSeparatedByString:@"/"];
            new_file.file_name = [parts lastObject];
            
            if(new_file.downloaded){
                
                NSDate *updated = [df dateFromString:[file objectForKey:@"last_modified"]];
                
                if(updated > new_file.downloaded){
                    new_file.update_available = [NSNumber numberWithInt:1];
                }
            }
            
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
