//
//  UpdateModuleCoursework.m
//  Saint Portal
//
//  Created by David Foster on 10/11/2014.
//  Copyright (c) 2014 David Foster. All rights reserved.
//

#import "UpdateModuleCoursework.h"
#import "SaintPortalAPI.h"
#import "AppDelegate.h"
#import "Coursework.h"
#import "Specification.h"

@interface UpdateModuleCoursework() <SaintPortalAPIDelegate>
@property (nonatomic, strong)Modules *module;
@property (nonatomic, strong)NSManagedObjectContext *context;
@property (nonatomic, strong)id delegate;
@property BOOL status;
@end

@implementation UpdateModuleCoursework

-(void)updateCourseworkForModule:(Modules *)module withDelegate:(id)delegate{
    
    self.module = module;
    self.context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    self.delegate = delegate;
    self.status = false;
    
    NSMutableDictionary *data = [[NSMutableDictionary alloc] init];
    [data setValue:self.module.module_id forKey:@"module_id"];
    
    SaintPortalAPI *api = [[SaintPortalAPI alloc] init];
    
    [api APIRequest:UpdateModuleCourseworkRequest withData:data withDelegate:self];
    
}

-(void)APICallbackHandler:(NSDictionary *)data{
 
    NSMutableArray *assignment_list = [[NSMutableArray alloc] init];
    
    //Check all objects are in core data
    
    if([[data valueForKey:@"coursework_exists"] boolValue]){
        
        for (NSDictionary *assignment in [data valueForKey:@"coursework_details"]){
            
            [assignment_list addObject:[NSNumber numberWithInteger:[[assignment objectForKey:@"coursework_id"] integerValue]]];
            
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
                
                [self updateCourseworkFile:[assignment objectForKey:@"coursework_file"] forCoursework:new_coursework];
                
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
                
                [self updateCourseworkFile:[assignment objectForKey:@"coursework_file"] forCoursework:new_coursework];

            }
            
            NSError *error;
            [self.context save:&error];
            
        }
    }
    
    //Remove any coursework items no longer on central database
    NSArray *deleteingAssignmenets = [NSArray arrayWithArray:assignment_list];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (coursework_id IN %@)", deleteingAssignmenets];
    
    NSSet *assignmentsToDelete = [self.module.module_assignments filteredSetUsingPredicate:predicate];
    
    for(Coursework *deleteCoursework in assignmentsToDelete){
        
        [self.context deleteObject:deleteCoursework];
        [self.module removeModule_assignmentsObject:deleteCoursework];
    }
 
    self.status = true;
    
    [self.delegate moduleCourseworkUpdateSuccess];
}

-(void) APIErrorHandler:(NSError *)error{

    self.status = true;
    
    [self.delegate moduleCourseworkUpdateFailure:error];
    
}

-(BOOL)getStatus{
    
    return self.status;
    
}

-(void)updateCourseworkFile:(NSDictionary *)fileData forCoursework:(Coursework *)coursework{
    
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"Specification"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"file_id = %@", [fileData objectForKey:@"file_id"]];
    
    NSError *error = nil;
    NSUInteger count = [self.context countForFetchRequest:request error:&error];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    if(count == 0){
        
        Specification *file = [NSEntityDescription insertNewObjectForEntityForName:@"Specification"
                                                            inManagedObjectContext:self.context];
        
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
        
        coursework.specification = file;
        
        NSError *saveError;
        [self.context save:&saveError];
        
        
    }else{
        NSArray *files = [self.context executeFetchRequest:request error:&error];
        Specification* file = [files firstObject];
    
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
        
        coursework.specification = file;
        
        NSError *saveError;
        [self.context save:&saveError];
    
    }
     
}

@end
