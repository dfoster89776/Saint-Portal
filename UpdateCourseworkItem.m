//
//  UpdateCourseworkItem.m
//  Saint Portal
//
//  Created by David Foster on 09/12/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "UpdateCourseworkItem.h"
#import "SaintPortalAPI.h"
#import "AppDelegate.h"
#import "Coursework.h"
#import "Specification.h"
#import "Coursework_Directory.h"
#import "DirectoryUpdate.h"
#import "Modules.h"


@interface UpdateCourseworkItem () <SaintPortalAPIDelegate>
@property (nonatomic, strong) id delegate;
@property (strong, nonatomic) NSManagedObjectContext* context;
@property (strong, nonatomic) Modules* module;
@end

@implementation UpdateCourseworkItem

-(void)updateCourseworkItemWithID:(NSNumber *)coursework_id withDelegate:(id)delegate{
    
    NSLog(@"Updating coursework item for id: %i", [coursework_id intValue]);

    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    
    self.delegate = delegate;
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:coursework_id forKey:@"coursework_id"];
    
    [api APIRequest:UpdateCourseworkItemRequest withData:data withDelegate:self];
        
}

-(void)APICallbackHandler:(NSDictionary *)data{
    
    NSLog(@"Callback data: %@", data);
    
    NSError *error;
    
    if([[data valueForKey:@"coursework_exists"] boolValue]){
        
        for (NSDictionary *assignment in [data valueForKey:@"coursework_details"]){
            
            int moduleid = [[assignment objectForKey:@"module_id"] intValue];
            NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Modules"];
            request.predicate = [NSPredicate predicateWithFormat:@"module_id = %i", moduleid];
            
            NSArray* result = [self.context executeFetchRequest:request error:&error];
            
            self.module = [result firstObject];
            
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"coursework_id == %i", [[assignment objectForKey:@"coursework_id"] integerValue]];
            
            NSSet *matches = [self.module.module_assignments filteredSetUsingPredicate:predicate];
            
            if([matches count] == 0){
                
                Coursework *new_coursework = [NSEntityDescription insertNewObjectForEntityForName:@"Coursework"
                                                                           inManagedObjectContext:self.context];
                
                new_coursework.coursework_id = [NSNumber numberWithInteger:[[assignment objectForKey:@"coursework_id"] integerValue]];
                new_coursework.coursework_name = [assignment objectForKey:@"coursework_name"];
                new_coursework.assignments_module = self.module;
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dueDate = [df dateFromString:[assignment objectForKey:@"due_date"]];
                
                new_coursework.coursework_due = dueDate;
                
                NSDate *feedbackDate = [df dateFromString:[assignment objectForKey:@"feedback_date"]];
                new_coursework.coursework_feedback_date = feedbackDate;
                
                new_coursework.coursework_weighting = [NSNumber numberWithInteger:[[assignment objectForKey:@"weighting"] integerValue]];
                
                new_coursework.coursework_description = [assignment objectForKey:@"description"];
                
                if([assignment objectForKey:@"directory_details"]){
                    [self updateDirectoryForCoursework:new_coursework withData:assignment];
                }
                
                new_coursework.specification = new_coursework.specification = [UpdateCourseworkItem updateCourseworkFile:[assignment objectForKey:@"coursework_file"] withContext:self.context];
                
                new_coursework.submitted = [NSNumber numberWithInteger:[[assignment objectForKey:@"submitted"] integerValue]];
                
                [self.module addModule_assignmentsObject:new_coursework];
                
            }else if([matches count] > 0){
                
                Coursework *new_coursework = [[matches allObjects] firstObject];
                new_coursework.coursework_id = [NSNumber numberWithInteger:[[assignment objectForKey:@"coursework_id"] integerValue]];
                new_coursework.coursework_name = [assignment objectForKey:@"coursework_name"];
                new_coursework.assignments_module = self.module;
                
                NSDateFormatter *df = [[NSDateFormatter alloc] init];
                [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                NSDate *dueDate = [df dateFromString:[assignment objectForKey:@"due_date"]];
                
                new_coursework.coursework_due = dueDate;
                
                NSDate *feedbackDate = [df dateFromString:[assignment objectForKey:@"feedback_date"]];
                new_coursework.coursework_feedback_date = feedbackDate;
                
                new_coursework.coursework_weighting = [NSNumber numberWithInteger:[[assignment objectForKey:@"weighting"] integerValue]];
                
                new_coursework.coursework_description = [assignment objectForKey:@"description"];
                
                new_coursework.submitted = [NSNumber numberWithInteger:[[assignment objectForKey:@"submitted"] integerValue]];
                
                if([assignment objectForKey:@"directory_details"]){
                    [self updateDirectoryForCoursework:new_coursework withData:assignment];
                }else if (new_coursework.coursework_directory != nil){
                    [self.context deleteObject:new_coursework.coursework_directory];
                    new_coursework.coursework_directory = nil;
                }
                
                new_coursework.specification= [UpdateCourseworkItem updateCourseworkFile:[assignment objectForKey:@"coursework_file"] withContext:self.context];
            }
        }
    }
    
    [self.context save:&error];
    
    [self.delegate courseworkItemUpdateSuccess];
    
}

-(void)APIErrorHandler:(NSError *)error{
    
    [self.delegate courseworkItemUpdateSuccess];
    
}

+(Specification *)updateCourseworkFile:(NSDictionary *)fileData withContext:(NSManagedObjectContext*)context{
    
    Specification *file;
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Specification"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"file_id = %@", [fileData objectForKey:@"file_id"]];
    
    NSError *error = nil;
    NSUInteger count = [context countForFetchRequest:request error:&error];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if(count == 0){
        
        file = [NSEntityDescription insertNewObjectForEntityForName:@"Specification"
                                             inManagedObjectContext:context];
        
        file.file_id = [NSNumber numberWithInteger:[[fileData objectForKey:@"file_id"] integerValue]];
        file.file_url = [fileData objectForKey:@"file_url"];
        
        NSLog(@"File url: %@", file.file_url);
        
        NSArray *parts = [file.file_url componentsSeparatedByString:@"/"];
        file.file_name = [parts lastObject];
        
        if(file.downloaded){
            
            NSDate *updated = [df dateFromString:[fileData objectForKey:@"last_modified"]];
            
            if(updated > file.downloaded){
                file.update_available = [NSNumber numberWithInt:1];
            }
        }
        
        
    }else{
        NSArray *files = [context executeFetchRequest:request error:&error];
        file = [files firstObject];
        
        NSLog(@"Adding coursework file: %@", [fileData objectForKey:@"file_url"]);
        
        file.file_id = [NSNumber numberWithInteger:[[fileData objectForKey:@"file_id"] integerValue]];
        file.file_url = [fileData objectForKey:@"file_url"];
        
        NSArray *parts = [file.file_url componentsSeparatedByString:@"/"];
        file.file_name = [parts lastObject];
        
        if(file.downloaded){
            
            NSDate *updated = [df dateFromString:[fileData objectForKey:@"last_modified"]];
            
            if(updated > file.downloaded){
                file.update_available = [NSNumber numberWithInt:1];
            }
        }
        
    }
    
    return file;
    
}

-(void)updateDirectoryForCoursework:(Coursework *)coursework withData:(NSDictionary *)data{
    
    NSLog(@"Updating coursework directory: %@", [data objectForKey:@"directory"]);
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Coursework_Directory"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"directory_id = %@", [data objectForKey:@"directory"]];
    
    NSError *error = nil;
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    
    Coursework_Directory *root;
    
    if(count == 0){
        
        root = [NSEntityDescription insertNewObjectForEntityForName:@"Coursework_Directory"
                                             inManagedObjectContext:self.context];
        
    }else if (count == 1){
        
        NSArray *details = [self.context executeFetchRequest:request error:&error];
        root = [details firstObject];
        
    }
    
    root.directory_id = [NSNumber numberWithInteger:[[data objectForKey:@"directory"] integerValue]];
    
    coursework.coursework_directory = root;
    
    DirectoryUpdate *du = [[DirectoryUpdate alloc] init];
    [du updateCourseworkDirectory:root withData:[data objectForKey:@"directory_details"]];
    
}


@end
